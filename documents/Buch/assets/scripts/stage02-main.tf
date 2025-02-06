# snapshot
resource "vsphere_virtual_machine_snapshot" "stage_snapshot" {
  for_each             = toset(local.vm_uuids)
  virtual_machine_uuid = each.key
  snapshot_name        = "stage_02"
  description          = "Automatic Stage Provisioning Snapshot"
  memory               = true
  quiesce              = true
  remove_children      = true
  consolidate          = true

  provisioner "local-exec" {
    when    = destroy
    command = "../../ansible/rollback_snapshot.sh ${self.virtual_machine_uuid} stage_02"
  }
}

# virtual maschines
data "vsphere_virtual_machine" "scada" {
  datacenter_id = data.vsphere_datacenter.dc.id
  name          = "scada"
}

# get addresses
locals {
  scada_address = [for ip in data.vsphere_virtual_machine.scada.guest_ip_addresses : ip if startswith(ip, "172.20.")][0]
}

# provision
resource "terraform_data" "scada_provisioning" {
  depends_on = [vsphere_virtual_machine_snapshot.stage_snapshot]
  provisioner "file" {
    when = create
    connection {
      host             = local.scada_address
      user             = "administrator"
      bastion_host     = var.bastion_settings.host
      bastion_user     = var.bastion_settings.username
      bastion_password = var.bastion_settings.password
      agent            = true
    }
    on_failure  = fail
    source      = "./extra/project.zip"
    destination = "/home/administrator/project.zip"
  }
  provisioner "remote-exec" {
    when = create
    connection {
      host             = local.scada_address
      user             = "administrator"
      bastion_host     = var.bastion_settings.host
      bastion_user     = var.bastion_settings.username
      bastion_password = var.bastion_settings.password
      agent            = true
    }
    on_failure = fail
    script     = "./scripts/scada.sh"
  }
}
