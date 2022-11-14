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
  # iscsid required for openebs-jiva
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/dev/local-vols",
      "mkdir -p /home/dev/rke2-artifacts",
      "sudo systemctl enable iscsid.service",
      "sudo systemctl start iscsid.service"
    ]

    connection {
      type        = "ssh"
      user        = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host        = var.ip_addr
    }
  }

  provisioner "file" {
    content     = templatefile("${path.module}/files/config.yaml.tftpl", { primary = var.primary, role = var.role, ip_addr = var.ip_addr, cluster_host = var.cluster_host, node_host = var.node_host, domain = var.domain })
    destination = "/home/dev/config.yaml"
    connection {
      type        = "ssh"
      user        = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host        = var.ip_addr
    }
  }

  provisioner "file" {
    source      = "${path.module}/files/artifacts/"
    destination = "/home/dev/rke2-artifacts/"
    connection {
      type        = "ssh"
      user        = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host        = var.ip_addr
    }
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo dpkg -i /home/dev/nfs-common_1.3.4-2.5+deb10u1_amd64.deb",
  #     "mkdir -p /home/dev/nfs",
  #     "sudo mkdir -p /root/rke2-artifacts",
  #     "sudo mount -t nfs4 192.168.0.232:/ /home/dev/nfs",
  #     "sudo cp /home/dev/nfs/kubernetes/rke2/${var.rke2_version}/* /root/rke2-artifacts/"
  #   ]
  #   connection {
  #     type     = "ssh"
  #     user     = "dev"
  #     private_key = file("${var.ssh_priv_key_path}")
  #     host     = var.ip_addr
  #   }
  # }

  # Execute all required processes
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/rancher/rke2",
      "sudo cp /home/dev/config.yaml /etc/rancher/rke2/config.yaml",
      "sudo INSTALL_RKE2_ARTIFACT_PATH=/home/dev/rke2-artifacts %{if var.role != "server"}INSTALL_RKE2_TYPE='agent'%{endif} sh /home/dev/rke2-artifacts/install.sh",
      "sudo systemctl enable rke2-${var.role}.service"
    ]

    connection {
      type        = "ssh"
      user        = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host        = var.ip_addr
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl start rke2-${var.role}.service"
    ]

    on_failure = continue

    connection {
      type        = "ssh"
      user        = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host        = var.ip_addr
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
