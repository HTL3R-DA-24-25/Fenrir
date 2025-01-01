packer {
    required_plugins {
      vsphere = {
        version = "~> 1"
        source = "github.com/hashicorp/vsphere"
      }
    }
  }

  source "vsphere-iso" "linux_server" {
    vm_name    = "linux_server"
    vm_version = 20
    folder     = "01_Fenrir_VMs/templates"
    CPUs       = 4
    RAM        = 4096

    guest_os_type = "ubuntu64Guest"
    firmware      = "efi"
    convert_to_template = true

    insecure_connection = true
    ip_wait_address     = "172.20.0.0/16"
    ssh_timeout         = "15m"

    iso_paths            = ["[${var.vsphere_datastore_ssd}] isos/ubuntu-24.04-live-server-amd64.iso"]

    // cloud-init
    floppy_label   = "cidata"
    floppy_content = {
      "meta-data" = ""
      "user-data" = templatefile("autoinstall.yaml", {
          bastion_ssh_public          = file("../../../keys/id_ed25519.pub"),
          provisioning_network_config = base64encode(file("20-provisioning.yaml")),
          image_password              = var.image_password
        })
    }

    network_adapters {
      network      = "fenrir_management"
      network_card = "vmxnet3"
    }
    network_adapters {
      network      = "VLAN423-INET"
      network_card = "vmxnet3"
    }

    storage {
      disk_size             = 60000
      disk_thin_provisioned = true
    }
    disk_controller_type = ["pvscsi"]

    // Modified boot command from VMware's example repo https://github.com/vmware-samples/packer-examples-for-vsphere/blob/fe84fb98ef0743811ef1907851583434e8a21672/builds/linux/ubuntu/20-04-lts/linux-ubuntu.pkr.hcl#L95-L103
    boot_wait = "3s"
    boot_command = [
      "<esc><wait>c",
      "linux /casper/vmlinuz --- autoinstall ds=\"nocloud\"",
      "<enter><wait>",
      "initrd /casper/initrd",
      "<enter><wait>",
      "boot",
      "<enter>"
    ]

    username       = var.vsphere_user
    password       = var.vsphere_password
    vcenter_server = var.vsphere_vcenter
    datacenter     = var.vsphere_datacenter
    resource_pool  = var.vsphere_resource_pool
    cluster        = var.vsphere_cluster
    datastore      = var.vsphere_datastore

    communicator            = "ssh"
    ssh_username            = "administrator"
    ssh_bastion_host        = "10.40.21.40"
    ssh_bastion_username    = "administrator"
    ssh_bastion_password    = var.bastion_password
    ssh_bastion_agent_auth  = true
    ssh_private_key_file    = "../../../keys/id_ed25519"
  }

  build {
    sources = ["source.vsphere-iso.linux_server"]
    provisioner "shell" {
      inline = [
        "sudo systemctl disable systemd-networkd-wait-online.service",
        "sudo systemctl mask systemd-networkd-wait-online.service",
      ]
    }
    provisioner "shell" {
        script = "./post_install.sh"
    }
}
