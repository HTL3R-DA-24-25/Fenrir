# snapshot
resource "vsphere_virtual_machine_snapshot" "stage_snapshot" {
  for_each             = toset(local.vm_uuids)
  virtual_machine_uuid = each.key
  snapshot_name        = "stage_03"
  description          = "Automatic Stage Provisioning Snapshot"
  memory               = true
  quiesce              = true
  remove_children      = true
  consolidate          = true

  provisioner "local-exec" {
    when    = destroy
    command = "../../ansible/rollback_snapshot.sh ${self.virtual_machine_uuid} stage_03"
  }
}

# virtual maschines
data "vsphere_virtual_machine" "addc_primary" {
  datacenter_id = data.vsphere_datacenter.dc.id
  name          = "addc_primary"
}

data "vsphere_virtual_machine" "addc_secondary" {
  datacenter_id = data.vsphere_datacenter.dc.id
  name          = "addc_secondary"
}

# provisioner
locals {
  addc_primary_address   = [for ip in data.vsphere_virtual_machine.addc_primary.guest_ip_addresses : ip if startswith(ip, "172.20.")][0]
  addc_secondary_address = [for ip in data.vsphere_virtual_machine.addc_secondary.guest_ip_addresses : ip if startswith(ip, "172.20.")][0]
}

resource "terraform_data" "setup_domain_controller" {
  depends_on = [vsphere_virtual_machine_snapshot.stage_snapshot]
  provisioner "local-exec" {
    on_failure = fail
    when       = create
    command    = "../../ansible/execute_stage_03.sh ${local.addc_primary_address} ${data.vsphere_virtual_machine.addc_primary.uuid} ${local.addc_secondary_address} ${data.vsphere_virtual_machine.addc_secondary.uuid}"
  }
}
