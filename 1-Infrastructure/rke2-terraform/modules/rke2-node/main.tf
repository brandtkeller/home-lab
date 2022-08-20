terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.10"
    }
  }
}

resource "proxmox_vm_qemu" "rke2_node" {
  name        = var.name
  target_node = "pve"
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
  network {
    model  = "virtio"
    bridge = "vmbr1"
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  provisioner "file" {
    content      = templatefile("${path.module}/files/config.yaml.tftpl", { primary=var.primary, role=var.role, ip_addr=var.ip_addr, server_addr=var.server_addr})
    destination = "/home/dev/config.yaml"
    connection {
      type     = "ssh"
      user     = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host     = var.ip_addr
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt install -y nfs-common",
      "mkdir -p /home/dev/nfs",
      "sudo mkdir -p /root/rke2-artifacts",
      "sudo mount -t nfs4 192.168.0.232:/ /home/dev/nfs",
      "sudo cp /home/dev/nfs/kubernetes/rke2/${var.rke2_version}/* /root/rke2-artifacts/"
    ]
    connection {
      type     = "ssh"
      user     = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host     = var.ip_addr
    }
  }

# Execute all required processes
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/rancher/rke2",
      "sudo cp /home/dev/config.yaml /etc/rancher/rke2/config.yaml",
      "sudo INSTALL_RKE2_ARTIFACT_PATH=/root/rke2-artifacts sh /root/rke2-artifacts/install.sh",
      "sudo systemctl enable rke2-server.service"
    ]

    connection {
      type     = "ssh"
      user     = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host     = var.ip_addr
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl start rke2-server.service"
    ]

    on_failure = continue

    connection {
      type     = "ssh"
      user     = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host     = var.ip_addr
    }
  }
  
  # Cloud Init Settings
  ipconfig0 = "ip=${var.ip_addr}/24,gw=192.168.1.1"
  nameserver = var.nameservers
  ciuser    = "dev"
  cipassword = var.password
  sshkeys   = <<EOF
  ${file(var.ssh_pub_key_path)}
  EOF
}

# resource "proxmox_vm_qemu" "secondary_servers" {
#   count       = 2
#   name        = "rke2-server-0${count.index + 2}"
#   target_node = "pve"
#   clone       = "ubuntu-cloudimg"
#   os_type     = "cloud-init"
#   cores       = 4
#   sockets     = "2"
#   cpu         = "host"
#   memory      = 16384
#   scsihw      = "virtio-scsi-pci"
#   bootdisk    = "scsi0"
#   # bios        = "ovmf"
#   disk {
#     size    = "60G"
#     type    = "scsi"
#     storage = "ssdpool1"
#   }
#   network {
#     model  = "virtio"
#     bridge = "vmbr0"
#   }
#   lifecycle {
#     ignore_changes = [
#       network,
#     ]
#   }

#   provisioner "file" {
#     content      = templatefile("${path.module}/files/config.yaml.tftpl", { primary=false, role="server" })
#     destination = "/home/dev/config.yaml"
#     connection {
#       type     = "ssh"
#       user     = "dev"
#       private_key = file("${var.ssh_priv_key_path}")
#       host     = "192.168.0.6${count.index + 1}"
#     }
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt install -y nfs-common",
#       "mkdir -p /home/dev/nfs",
#       "sudo mkdir -p /root/rke2-artifacts",
#       "sudo mount -t nfs4 192.168.0.232:/ /home/dev/nfs",
#       "sudo cp /home/dev/nfs/kubernetes/rke2/v1.24.3+rke2r1/* /root/rke2-artifacts/"
#     ]
#     connection {
#       type     = "ssh"
#       user     = "dev"
#       private_key = file("${var.ssh_priv_key_path}")
#       host     = "192.168.0.6${count.index + 1}"
#     }
#   }

# # Execute all required processes
#   provisioner "remote-exec" {
#     inline = [
#       "sudo mkdir -p /etc/rancher/rke2",
#       "sudo cp /home/dev/config.yaml /etc/rancher/rke2/config.yaml",
#       "sudo INSTALL_RKE2_ARTIFACT_PATH=/root/rke2-artifacts sh /root/rke2-artifacts/install.sh",
#       "sudo systemctl enable rke2-server.service"
#     ]

#     connection {
#       type     = "ssh"
#       user     = "dev"
#       private_key = file("${var.ssh_priv_key_path}")
#       host     = "192.168.0.6${count.index + 1}"
#     }
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo systemctl start rke2-server.service"
#     ]

#     on_failure = continue

#     connection {
#       type     = "ssh"
#       user     = "dev"
#       private_key = file("${var.ssh_priv_key_path}")
#       host     = "192.168.0.6${count.index + 1}"
#     }
#   }
  
#   # Cloud Init Settings
#   ipconfig0 = "ip=192.168.0.6${count.index + 1}/24,gw=192.168.0.1"
#   ciuser    = "dev"
#   cipassword = var.vm_password
#   sshkeys   = <<EOF
#   ${file(var.ssh_pub_key_path)}
#   EOF

#   depends_on = [
#     proxmox_vm_qemu.primary_server
#   ]
# }

# resource "proxmox_vm_qemu" "agents" {
#   count       = 1
#   name        = "rke2-agent-0${count.index + 1}"
#   target_node = "pve"
#   clone       = "ubuntu-cloudimg"
#   os_type     = "cloud-init"
#   cores       = 4
#   sockets     = "2"
#   cpu         = "host"
#   memory      = 16384
#   scsihw      = "virtio-scsi-pci"
#   bootdisk    = "scsi0"
#   # bios        = "ovmf"
#   disk {
#     size    = "60G"
#     type    = "scsi"
#     storage = "ssdpool1"
#   }
#   network {
#     model  = "virtio"
#     bridge = "vmbr0"
#   }
#   lifecycle {
#     ignore_changes = [
#       network,
#     ]
#   }

#   provisioner "file" {
#     content      = templatefile("${path.module}/files/config.yaml.tftpl", { primary=false, role="agent" })
#     destination = "/home/dev/config.yaml"
#     connection {
#       type     = "ssh"
#       user     = "dev"
#       private_key = file("${var.ssh_priv_key_path}")
#       host     = "192.168.0.6${count.index + 5}"
#     }
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt install -y nfs-common",
#       "mkdir -p /home/dev/nfs",
#       "sudo mkdir -p /root/rke2-artifacts",
#       "sudo mount -t nfs4 192.168.0.232:/ /home/dev/nfs",
#       "sudo cp /home/dev/nfs/kubernetes/rke2/v1.24.3+rke2r1/* /root/rke2-artifacts/"
#     ]
#     connection {
#       type     = "ssh"
#       user     = "dev"
#       private_key = file("${var.ssh_priv_key_path}")
#       host     = "192.168.0.6${count.index + 5}"
#     }
#   }

# # Execute all required processes
#   provisioner "remote-exec" {
#     inline = [
#       "sudo mkdir -p /etc/rancher/rke2",
#       "sudo cp /home/dev/config.yaml /etc/rancher/rke2/config.yaml",
#       "sudo INSTALL_RKE2_ARTIFACT_PATH=/root/rke2-artifacts INSTALL_RKE2_TYPE='agent' sh /root/rke2-artifacts/install.sh",
#       "sudo systemctl enable rke2-agent.service"
#     ]

#     connection {
#       type     = "ssh"
#       user     = "dev"
#       private_key = file("${var.ssh_priv_key_path}")
#       host     = "192.168.0.6${count.index + 5}"
#     }
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo systemctl start rke2-agent.service"
#     ]

#     on_failure = continue

#     connection {
#       type     = "ssh"
#       user     = "dev"
#       private_key = file("${var.ssh_priv_key_path}")
#       host     = "192.168.0.6${count.index + 5}"
#     }
#   }
  
#   # Cloud Init Settings
#   ipconfig0 = "ip=192.168.0.6${count.index + 5}/24,gw=192.168.0.1"
#   ciuser    = "dev"
#   cipassword = var.vm_password
#   sshkeys   = <<EOF
#   ${file(var.ssh_pub_key_path)}
#   EOF

#   depends_on = [
#     proxmox_vm_qemu.primary_server, 
#     proxmox_vm_qemu.secondary_servers
#   ]
# }

# resource "null_resource" "kubeconfig" {
#   provisioner "local-exec" {
#     command = "scp -i ${var.ssh_priv_key_path} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null dev@192.168.0.60:/etc/rancher/rke2/rke2.yaml ."
#   }
#   depends_on = [
#     proxmox_vm_qemu.primary_server, 
#     proxmox_vm_qemu.secondary_servers
#   ]
# }
