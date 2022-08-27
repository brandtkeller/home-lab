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

module "rke2-server-01" {
  source = "./modules/rke2-node"

  name    = "rke2-server-01.kellerhome.us"
  role    = "server"
  primary = true

  storage_size = "300G"
  memory       = 32768

  ip_addr     = "192.168.1.20"
  server_addr = "192.168.1.20"
  nameservers = "192.168.1.21 192.168.1.22"
  password    = var.password
}

module "rke2-server-02" {
  source = "./modules/rke2-node"

  name = "rke2-server-02.kellerhome.us"
  role = "server"
  primary = false

  storage_size = "300G"
  memory = 32768

  ip_addr = "192.168.1.21"
  server_addr = "k8s.kellerhome.us"
  nameservers = "192.168.1.20 192.168.1.22"
  password = var.password
}

module "rke2-server-03" {
  source = "./modules/rke2-node"

  name = "rke2-server-03.kellerhome.us"
  role = "server"
  primary = false

  storage_size = "300G"
  memory = 32768

  ip_addr = "192.168.1.22"
  server_addr = "k8s.kellerhome.us"
  nameservers = "192.168.1.20 192.168.1.22"
  password = var.password
}

# module "rke2-agent-01" {
#   source = "./modules/rke2-node"

#   name = "rke2-agent-01.kellerhome.us"
#   role = "agent"
#   primary = false

#   ip_addr = "192.168.1.23"
#   server_addr = "k8s.kellerhome.us"
#   nameservers = "192.168.1.20 192.168.1.21 192.168.1.22"
#   password = var.password
# }