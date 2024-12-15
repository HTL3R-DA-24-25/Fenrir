"""
Author: Julian Burger<cauvmou.8855@gmail.com>
"""

import argparse
import atexit
import io
import json
import sys
from dataclasses import dataclass
from time import sleep

import yaml
from pyVmomi import vim
from pyVim.connect import SmartConnect, Disconnect
import logging

logger = logging.getLogger(__name__ if __name__ != "__main__" else "create_filtering_rules")


@dataclass
class EnvironmentSettings:
    vcenter_username: str
    vcenter_password: str
    vcenter_hostname: str
    datacenter_name: str


def read_environment_settings(variables_file: str, secrets_file: str) -> EnvironmentSettings:
    try:
        loaded: any = {}
        logger.info(f"Reading environment settings from '{variables_file}'")
        with open(variables_file, "rt") as stream:
            data: any = yaml.safe_load(stream)
            loaded.update(data)
        logger.info(f"Reading environment settings from '{secrets_file}'")
        with open(secrets_file, "rt") as stream:
            data: any = yaml.safe_load(stream)
            loaded.update(data)
        return EnvironmentSettings(loaded["vcenter_username"], loaded["vcenter_password"], loaded["vcenter_hostname"], loaded["datacenter_name"])
    except Exception as e:
        logger.error(e)
        exit(1)
    pass


def setup_logging():
    logger.setLevel(logging.DEBUG)
    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(logging.Formatter("[%(asctime)s - %(levelname)s - %(name)s]: %(message)s"))
    logger.addHandler(handler)


def get_filter_config_keys(pg: vim.dvs.DistributedVirtualPortgroup) -> list[str]:
    return [config.key for config in pg.config.defaultPortConfig.filterPolicy.filterConfig or []]


def create_filter_config() -> vim.dvs.DistributedVirtualPort.TrafficFilterConfigSpec:
    # Rule 0
    dhcp_accept_qualifier = vim.dvs.TrafficRule.IpQualifier()
    dhcp_accept_qualifier.sourceAddress = vim.SingleIp()
    dhcp_accept_qualifier.sourceAddress.address = "0.0.0.0"
    dhcp_accept_qualifier.sourceAddress.negate = False
    dhcp_accept_qualifier.sourceIpPort = vim.dvs.TrafficRule.SingleIpPort()
    dhcp_accept_qualifier.sourceIpPort.portNumber = 68
    dhcp_accept_qualifier.sourceIpPort.negate = False
    dhcp_accept_qualifier.destinationAddress = vim.SingleIp()
    dhcp_accept_qualifier.destinationAddress.address = "255.255.255.255"
    dhcp_accept_qualifier.destinationAddress.negate = False
    dhcp_accept_qualifier.destinationIpPort = vim.dvs.TrafficRule.SingleIpPort()
    dhcp_accept_qualifier.destinationIpPort.portNumber = 67
    dhcp_accept_qualifier.destinationIpPort.negate = False
    dhcp_accept_qualifier.protocol = vim.IntExpression()
    dhcp_accept_qualifier.protocol.value = 17
    dhcp_accept_qualifier.protocol.negate = False
    dhcp_accept = vim.dvs.TrafficRule()
    dhcp_accept.sequence = 10
    dhcp_accept.qualifier = [dhcp_accept_qualifier]
    dhcp_accept.action = vim.dvs.TrafficRule.AcceptAction()
    dhcp_accept.description = "DHCP Discovery Accept"
    dhcp_accept.direction = "both"

    # Rule 1
    bastion_source_accept_qualifier = vim.dvs.TrafficRule.IpQualifier()
    bastion_source_accept_qualifier.sourceAddress = vim.SingleIp()
    bastion_source_accept_qualifier.sourceAddress.address = "172.20.0.1"
    bastion_source_accept_qualifier.sourceAddress.negate = False
    bastion_source_accept = vim.dvs.TrafficRule()
    bastion_source_accept.sequence = 20
    bastion_source_accept.qualifier = [bastion_source_accept_qualifier]
    bastion_source_accept.action = vim.dvs.TrafficRule.AcceptAction()
    bastion_source_accept.description = "From Bastion Accept"
    bastion_source_accept.direction = "both"

    # Rule 2
    bastion_destination_accept_qualifier = vim.dvs.TrafficRule.IpQualifier()
    bastion_destination_accept_qualifier.destinationAddress = vim.SingleIp()
    bastion_destination_accept_qualifier.destinationAddress.address = "172.20.0.1"
    bastion_destination_accept_qualifier.destinationAddress.negate = False
    bastion_destination_accept = vim.dvs.TrafficRule()
    bastion_destination_accept.sequence = 30
    bastion_destination_accept.qualifier = [bastion_destination_accept_qualifier]
    bastion_destination_accept.action = vim.dvs.TrafficRule.AcceptAction()
    bastion_destination_accept.description = "To Bastion Accept"
    bastion_destination_accept.direction = "both"

    # Rule 3
    bastion_not_source_drop_qualifier = vim.dvs.TrafficRule.IpQualifier()
    bastion_not_source_drop_qualifier.sourceAddress = vim.SingleIp()
    bastion_not_source_drop_qualifier.sourceAddress.address = "172.20.0.1"
    bastion_not_source_drop_qualifier.sourceAddress.negate = True
    bastion_not_source_drop = vim.dvs.TrafficRule()
    bastion_not_source_drop.sequence = 40
    bastion_not_source_drop.qualifier = [bastion_not_source_drop_qualifier]
    bastion_not_source_drop.action = vim.dvs.TrafficRule.DropAction()
    bastion_not_source_drop.description = "From Bastion Drop"
    bastion_not_source_drop.direction = "both"

    # Rule 4
    bastion_not_destination_drop_qualifier = vim.dvs.TrafficRule.IpQualifier()
    bastion_not_destination_drop_qualifier.destinationAddress = vim.SingleIp()
    bastion_not_destination_drop_qualifier.destinationAddress.address = "172.20.0.1"
    bastion_not_destination_drop_qualifier.destinationAddress.negate = True
    bastion_not_destination_drop = vim.dvs.TrafficRule()
    bastion_not_destination_drop.sequence = 50
    bastion_not_destination_drop.qualifier = [bastion_not_destination_drop_qualifier]
    bastion_not_destination_drop.action = vim.dvs.TrafficRule.DropAction()
    bastion_not_destination_drop.description = "To Bastion Drop"
    bastion_not_destination_drop.direction = "both"

    # Create ruleset
    filter_config = vim.dvs.DistributedVirtualPort.TrafficFilterConfigSpec()
    filter_config.inherited = False
    filter_config.agentName = "dvfilter-generic-vmware"
    filter_config.operation = "add"
    filter_config.trafficRuleset = vim.dvs.TrafficRuleset()
    filter_config.trafficRuleset.rules = [
        dhcp_accept,
        bastion_source_accept,
        bastion_destination_accept,
        bastion_not_source_drop,
        bastion_not_destination_drop
    ]
    filter_config.trafficRuleset.enabled = True
    return filter_config


def main():
    setup_logging()
    parser = argparse.ArgumentParser(
        prog="create_filtering_rules.py",
        description="Creates filtering rules on 'fenrir_management' dpg."
    )
    parser.add_argument("variables", type=str)
    parser.add_argument("secrets", type=str)
    args = parser.parse_args()
    settings = read_environment_settings(args.variables, args.secrets)
    service_instance = SmartConnect(
        host=settings.vcenter_hostname,
        user=settings.vcenter_username,
        pwd=settings.vcenter_password,
        disableSslCertValidation=True
    )
    atexit.register(Disconnect, service_instance)
    logger.info("Connected to vCenter")
    content = service_instance.RetrieveContent()
    # Get datacenter
    container = content.viewManager.CreateContainerView(content.rootFolder, [vim.Datacenter], True)
    datacenter: vim.Datacenter = [dc for dc in container.view if dc.name == settings.datacenter_name][0]
    if datacenter is None:
        logger.error("Datacenter not found!")
        exit(1)
    logger.info(f"Found datacenter: '{datacenter.name}'")
    logger.debug(datacenter)
    # Get portgroup
    container = content.viewManager.CreateContainerView(datacenter, [vim.dvs.DistributedVirtualPortgroup], True)
    pg: vim.dvs.DistributedVirtualPortgroup = [pg for pg in container.view if pg.name == "fenrir_management"][0]
    if pg is None:
        logger.error("DPG not found!")
        exit(1)
    logger.info(f"Found DPG: '{pg.key}'")

    spec = vim.dvs.DistributedVirtualPortgroup.ConfigSpec()
    spec.configVersion = pg.config.configVersion
    spec.defaultPortConfig = vim.dvs.DistributedVirtualPort.Setting()
    spec.defaultPortConfig.filterPolicy = vim.dvs.DistributedVirtualPort.FilterPolicy()
    spec.defaultPortConfig.filterPolicy.inherited = False

    # Erstellen
    spec.defaultPortConfig.filterPolicy.filterConfig = [create_filter_config()]
    # Löschen
    for config_key in get_filter_config_keys(pg):
        filter_config = vim.dvs.DistributedVirtualPort.TrafficFilterConfigSpec()
        filter_config.key = config_key
        filter_config.operation = "remove"
        spec.defaultPortConfig.filterPolicy.filterConfig.append(filter_config)

    task = pg.Reconfigure(spec)
    while task.info.state != vim.TaskInfo.State.success and task.info.state != vim.TaskInfo.State.error:
        logger.debug(task.info.state)
        sleep(0.1)
    # logger.info(task.info)

    logger.debug([config.key for config in pg.config.defaultPortConfig.filterPolicy.filterConfig])


if __name__ == "__main__":
    main()
