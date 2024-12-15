resource "vsphere_distributed_virtual_switch" "fenrir_dvs" {
  name          = "fenrir_dvs"
  description   = "The fenrir dvs for all networks!"
  datacenter_id = data.vsphere_datacenter.dc.id
  folder        = "01_Fenrir_Networks"

  uplinks        = ["uplink1"]
  active_uplinks = ["uplink1"]

  version = "8.0.0"

  allow_promiscuous      = true
  allow_forged_transmits = false
  allow_mac_changes      = false

  dynamic "host" {
    for_each = data.vsphere_host.host
    content {
      host_system_id = host.value["id"]
      devices        = ["vmnic5"]
    }
  }
}

resource "vsphere_distributed_port_group" "networks" {
  for_each                        = var.topology_networks
  depends_on                      = [vsphere_distributed_virtual_switch.fenrir_dvs]
  name                            = each.key
  description                     = each.value["description"]
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.fenrir_dvs.id

  vlan_id               = each.value["vlan_id"]
  vlan_override_allowed = false

  allow_forged_transmits = false
  allow_mac_changes      = false
  allow_promiscuous      = true

  auto_expand      = true
  type             = "earlyBinding"
  port_name_format = each.value["port_format"]
}

data "vsphere_network" "fenrir_management" {
  name          = "fenrir_management"
  datacenter_id = data.vsphere_datacenter.dc.id
  depends_on    = [vsphere_distributed_port_group.networks]
}

resource "terraform_data" "management_filtering" {
  depends_on = [vsphere_distributed_port_group.networks]
  provisioner "local-exec" {
    on_failure = fail
    command    = "../../ansible/create_filtering_rules.sh"
  }
}

resource "terraform_data" "bastion_build" {
  provisioner "local-exec" {
    on_failure = fail
    command    = "../../packer/build_bastion_image.sh"
  }
}

data "vsphere_virtual_machine" "bastion_base" {
  name          = "01_Fenrir_VMs/bastion_template"
  depends_on    = [terraform_data.bastion_build]
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "remote_access" {
  name          = "VLAN421-RemoteAccess"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "bastion" {
  name             = "bastion"
  folder           = "01_Fenrir_VMs"
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_resource_pool.pool.id

  num_cpus = 1
  memory   = 2048
  guest_id = "ubuntu64Guest"

  network_interface {
    network_id     = data.vsphere_network.remote_access.id
    adapter_type   = "vmxnet3"
    use_static_mac = true
    mac_address    = "00:50:56:bc:ea:d5"
  }
  network_interface {
    network_id     = data.vsphere_network.fenrir_management.id
    adapter_type   = "vmxnet3"
    use_static_mac = true
    mac_address    = "00:50:56:bc:45:1e"
  }

  ignored_guest_ips          = ["172.20.0.0/16"]
  wait_for_guest_net_timeout = 0

  disk {
    size  = 20
    label = "disk0"
  }
  scsi_type = "pvscsi"
  firmware  = "efi"

  clone {
    template_uuid = data.vsphere_virtual_machine.bastion_base.id
    linked_clone  = true
  }
}

resource "vsphere_virtual_machine_snapshot" "bastion_snapshot" {
  virtual_machine_uuid = vsphere_virtual_machine.bastion.uuid
  snapshot_name        = "stage_00"
  description          = "Stage00 Topology Snapshot"
  memory               = false
  quiesce              = false
  remove_children      = true
}

resource "terraform_data" "golden_image_build" {
  depends_on = [vsphere_virtual_machine_snapshot.bastion_snapshot]
  provisioner "local-exec" {
    when       = create
    on_failure = fail
    command    = "../../packer/build_golden_images.sh"
  }
}
