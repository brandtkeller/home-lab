terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.10"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://prox.kellerhome.us/api2/json"
}

## The primary server is actually a different physical machine

module "infra-server-02" {
  source = "../modules/rke2-node"

  name = "infra-server-02.kellerhome.us"
  role = "server"
  primary = false

  storage_size = "500G"
  memory = 32768

  ip_addr = "192.168.1.20"
  node_host = "infra-server-01"
  cluster_host = "infra"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

}

module "infra-server-03" {
  source = "../modules/rke2-node"

  name = "infra-server-03.kellerhome.us"
  role = "server"
  primary = false

  storage_size = "500G"
  memory = 32768

  ip_addr = "192.168.1.21"
  node_host = "infra-server-01"
  cluster_host = "infra"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

  depends_on = [
    module.infra-server-02
  ]
}

# module "rke2-agent-01" {
#   source = "../modules/rke2-node"

#   name = "rke2-agent-01.kellerhome.us"
#   role = "agent"
#   primary = false

#   ip_addr = "192.168.1.23"
#   server_addr = "k8s.kellerhome.us"
#   nameservers = "192.168.1.20 192.168.1.21 192.168.1.22"
#   password = var.password
# }