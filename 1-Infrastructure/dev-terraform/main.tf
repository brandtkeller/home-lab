terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.10"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://192.168.0.14:8006/api2/json"
  pm_tls_insecure = "true"
}

resource "proxmox_vm_qemu" "proxmox_vm" {
  count       = 1
  name        = "tf-vm-${count.index}"
  target_node = "pve"
  clone       = "ubuntu-cloudimg"
  os_type     = "cloud-init"
  cores       = 4
  sockets     = "2"
  cpu         = "host"
  memory      = 16384
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  # bios        = "ovmf"
  disk {
    size    = "60G"
    type    = "scsi"
    storage = "ssdpool1"
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  provisioner "file" {
    source      = "setup.sh"
    destination = "/tmp/setup.sh"
    connection {
      type     = "ssh"
      user     = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host     = "192.168.0.5${count.index + 1}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh",
    ]
    connection {
      type     = "ssh"
      user     = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host     = "192.168.0.5${count.index + 1}"
    }
  }
  
  # Cloud Init Settings
  ipconfig0 = "ip=192.168.0.5${count.index + 1}/24,gw=192.168.0.1"
  ciuser    = "dev"
  cipassword = var.vm_password
  sshkeys   = <<EOF
  ${file(var.ssh_pub_key_path)}
  EOF
}