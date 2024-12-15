locals {
  vm_names = [
    "addc_primary",
    "addc_secondary",
  ]
}

data "vsphere_virtual_machine" "vms_unique" {
  for_each      = toset(local.vm_names)
  datacenter_id = data.vsphere_datacenter.dc.id
  name          = each.key
}

locals {
  vm_uuids = [for vm in flatten([
    [for name in local.vm_names : data.vsphere_virtual_machine.vms_unique[name]],
  ]) : vm.uuid]
}
