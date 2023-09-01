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
  
  # Bootstrap file expected for any catered customization
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

  # zarf config file expected
  provisioner "file" {
    source      = "zarf-config.toml"
    destination = "/home/dev/zarf-config.toml"

    connection {
      type     = "ssh"
      user     = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host     = var.ip_addr
    }
  }

  provisioner "file" {
    content     = templatefile("zarf-config.toml", { primary = var.primary,join_server = var.join_server })
    destination = "/home/dev/zarf-config.toml"
    connection {
      type        = "ssh"
      user        = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host        = var.ip_addr
    }
  }

  provisioner "file" {
    source      = "artifacts/zarf_v0.29.0_Linux_amd64"
    destination = "/home/dev/zarf_v0.29.0_Linux_amd64"

    connection {
      type     = "ssh"
      user     = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host     = var.ip_addr
    }
  }

  provisioner "file" {
    source      = "artifacts/zarf-init-amd64-v0.29.0.tar.zst"
    destination = "/home/dev/zarf-init-amd64-v0.29.0.tar.zst"

    connection {
      type     = "ssh"
      user     = "dev"
      private_key = file("${var.ssh_priv_key_path}")
      host     = var.ip_addr
    }
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "/tmp/bootstrap.sh",
      "sudo mv /home/dev/zarf_v0.29.0_Linux_amd64 /usr/bin/zarf",
      "sudo chmod +x /usr/bin/zarf",
      #"cd /home/dev && sudo zarf package deploy zarf-init-amd64-v0.29.0.tar.zst %{if var.primary != true }--components=k3s%{else}--components=k3s,zarf-injector,zarf-seed-registry,zarf-registry,zarf-agent,git-server%{endif} --confirm"
      "cd /home/dev && ${var.zarf_command}"
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
