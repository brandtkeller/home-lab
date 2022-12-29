terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.10"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://prox.kellerhome.us:8006/api2/json"
}

resource "proxmox_vm_qemu" "rke2_support" {
  name        = "support-server-01"
  target_node = "pve"
  clone       = "ubuntu-cloudimg-prox"
  onboot      = true
  os_type     = "cloud-init"
  cores       = "4"
  sockets     = "1"
  cpu         = "host"
  memory      = "4096"
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  # bios        = "ovmf"
  disk {
    size    = "60G"
    type    = "scsi"
    storage = "ssdpool2"
  }
  disk {
    size    = "2000G"
    type    = "scsi"
    storage = "hddpool1"
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
  # iscsid required for openebs-jiva
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/dev/local-vols",
      "mkdir -p /home/dev/rke2-artifacts",
    ]

    connection {
      type        = "ssh"
      user        = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host        = "192.168.1.15"
    }
  }

  provisioner "file" {
    content     = templatefile("files/config.yaml.tftpl", { primary = true, role = "server", ip_addr = "192.168.1.15", cluster_host = "support", node_host = "support-server-01", domain = "kellerhome.us", join_server = "" })
    destination = "/home/dev/config.yaml"
    connection {
      type        = "ssh"
      user        = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host        = "192.168.1.15"
    }
  }

  provisioner "file" {
    source      = "files/disk-setup.sh"
    destination = "/tmp/disk-setup.sh"
    connection {
      type        = "ssh"
      user        = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host        = "192.168.1.15"
    }
  }

  provisioner "file" {
    source      = "artifacts/"
    destination = "/home/dev/rke2-artifacts/"
    connection {
      type        = "ssh"
      user        = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host        = "192.168.1.15"
    }
  }

  # Execute all required processes
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/rancher/rke2",
      "sudo mkdir -p /data",
      "sudo chmod +x /tmp/disk-setup.sh",
      "sudo /tmp/disk-setup.sh",
      "sudo mount -a",
      "sudo mkdir -p /data/volumes"
      "sudo chmod 777 /data",
      "sudo cp /home/dev/config.yaml /etc/rancher/rke2/config.yaml",
      "sudo INSTALL_RKE2_ARTIFACT_PATH=/home/dev/rke2-artifacts sh /home/dev/rke2-artifacts/install.sh",
      "sudo systemctl enable rke2-server.service"
    ]

    connection {
      type        = "ssh"
      user        = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host        = "192.168.1.15"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl start rke2-server.service"
    ]

    on_failure = continue

    connection {
      type        = "ssh"
      user        = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host        = "192.168.1.15"
    }
  }

  # Cloud Init Settings
  ipconfig0  = "ip=${"192.168.1.15"}/24,gw=192.168.1.1"
  nameserver = "192.168.0.130"
  ciuser     = "dev"
  cipassword = var.password
  sshkeys    = <<EOF
  ${file(var.ssh_pub_key_path)}
  EOF
}
