terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.10"
    }
  }
}

resource "proxmox_vm_qemu" "k3s_node" {
  name        = var.name
  target_node = var.pve_node
  clone       = var.clone_image
  onboot      = var.boot
  os_type     = "cloud-init"
  cores       = var.cpus
  agent       = 0
  sockets     = 1
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
    bridge = var.net_bridge
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"

    connection {
      type     = "ssh"
      user     = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host     = var.ip_addr
    }
  }
  
  # bootstrapping and initial artifact directory creation
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "/tmp/bootstrap.sh",
      "mkdir -p /home/dev/k3s-artifacts",
    ]

    connection {
      type        = "ssh"
      user        = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host        = var.ip_addr
    }
  }

  # config file for k3s installation templating
  provisioner "file" {
    content     = templatefile("${path.module}/files/config.yaml.tftpl", { primary = var.primary, taint = var.taint, role = var.role, ip_addr = var.ip_addr, cluster_host = var.cluster_host, node_host = var.node_host, domain = var.domain, join_server = var.join_server })
    destination = "/home/dev/config.yaml"
    connection {
      type        = "ssh"
      user        = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host        = var.ip_addr
    }
  }

  # Copy all artifacts to the node
  provisioner "file" {
    source      = "${path.module}/artifacts/"
    destination = "/home/dev/k3s-artifacts/"
    connection {
      type        = "ssh"
      user        = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host        = var.ip_addr
    }
  }

  # Execute all required processes
  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/dev/k3s-artifacts/k3s-amd64-${var.k3s_version} /usr/local/bin/k3s",
      "sudo chmod +x /usr/local/bin/k3s",
      "sudo mkdir -p /var/lib/rancher/k3s/agent/images/",
      "sudo cp /home/dev/k3s-artifacts/k3s-airgap-images-${var.k3s_version}-amd64.tar.zst /var/lib/rancher/k3s/agent/images/",
      "sudo mkdir -p /etc/rancher/k3s/",
      "sudo cp /home/dev/config.yaml /etc/rancher/k3s/config.yaml",
      "sudo INSTALL_K3S_SKIP_DOWNLOAD=true %{if var.role == "server"}INSTALL_K3S_EXEC='server'%{else}INSTALL_K3S_EXEC='agent'%{endif} sh /home/dev/k3s-artifacts/install.sh",
    ]

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
