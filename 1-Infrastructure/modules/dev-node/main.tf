terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.10"
    }
  }
}

resource "proxmox_vm_qemu" "dev_node" {
  name        = var.name
  target_node = var.pve_node
  clone       = var.clone_image
  os_type     = "cloud-init"
  cores       = var.cpus
  sockets     = "1"
  cpu         = "host"
  memory      = var.memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  # bios        = "ovmf"
  disk {
    size    = var.storage_size
    type    = "scsi"
    storage = var.storage_type
  }
  disk {
    size    = "80G"
    type    = "scsi"
    storage = "hddpool1"
  }
  network {
    model  = "virtio"
    bridge = var.net_bridge
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
      host     = var.ip_addr
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
      host     = var.ip_addr
    }
  }

  # Cloud Init Settings
  ipconfig0  = "ip=${var.ip_addr}/24,gw=192.168.1.1"
  nameserver = var.nameservers
  ciuser     = "dev"
  cipassword = var.password
  sshkeys    = <<EOF
  ${file(var.ssh_pub_key_path)}
  EOF
}
