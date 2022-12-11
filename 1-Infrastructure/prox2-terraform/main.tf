terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.10"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://prox2.kellerhome.us:8006/api2/json"
}

## The primary server is actually a different physical machine

module "infra-server-01" {
  source = "../modules/rke2-node"

  name = "infra-server-01.kellerhome.us"
  pve_node = "prox2"
  role = "server"
  primary = true

  storage_size = "1024G"
  storage_type = "hddpool1"
  memory = 16384
  cpus = 8

  net_bridge = "vmbr0"

  ip_addr = "192.168.1.22"
  node_host = "infra-server-01"
  cluster_host = "infra"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

}
