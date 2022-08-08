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
  pm_user         = "root@pam"
  pm_password     = ""
  pm_tls_insecure = "true"
}

resource "proxmox_vm_qemu" "proxmox_vm" {
  count       = 1
  name        = "tf-vm-${count.index}"
  target_node = "pve"
  clone       = "ubuntu-cloudimg"
  os_type     = "cloud-init"
  cores       = 4
  sockets     = "1"
  cpu         = "host"
  memory      = 2048
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  # bios        = "ovmf"
  disk {
    size    = "20G"
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
  # Cloud Init Settings
  ipconfig0 = "ip=192.168.0.5${count.index + 1}/24,gw=192.168.0.1"
  ciuser    = "dev"
  cipassword = ""
  sshkeys   = <<EOF
  ${var.ssh_key}
  EOF
}