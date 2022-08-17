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

module "rke2-master" {
  source = "./modules/rke2-node"

  name = "rke2-server-01"
  role = "server"

  ip_addr = "192.168.1.20"
  nameservers = "1.1.1.1"
  password = var.password
}