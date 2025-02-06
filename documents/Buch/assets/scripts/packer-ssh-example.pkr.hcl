source "vsphere-iso" "linux_server" {
  communicator            = "ssh"
  ssh_username            = "administrator"
  ssh_bastion_host        = "10.40.20.20"
  ssh_bastion_username    = "administrator"
  ssh_bastion_password    = var.bastion_password
  ssh_bastion_agent_auth  = true
}
