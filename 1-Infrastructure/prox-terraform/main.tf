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

## The primary server is actually a different physical machine

module "infra-server-01" {
  source = "../modules/rke2-node"

  name = "infra-server-01.kellerhome.us"
  boot = true
  join_server = ""
  pve_node = "pve"
  clone_image  = "ubuntu-cloudimg-prox"
  role = "server"
  primary = true

  storage_size = "500G"
  storage_type = "ssdpool2"
  memory = 32768
  cpus = 8

  ip_addr = "192.168.1.22"
  node_host = "infra-server-01"
  cluster_host = "infra"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

}

module "infra-server-02" {
  source = "../modules/rke2-node"

  name = "infra-server-02.kellerhome.us"
  boot = true
  join_server = "infra-server-01.kellerhome.us"
  pve_node = "pve"
  clone_image  = "ubuntu-cloudimg-prox"
  role = "server"
  primary = false

  storage_size = "500G"
  storage_type = "ssdpool2"
  memory = 32768
  cpus = 8

  ip_addr = "192.168.1.23"
  node_host = "infra-server-02"
  cluster_host = "infra"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

}

module "infra-server-03" {
  source = "../modules/rke2-node"

  name = "infra-server-03.kellerhome.us"
  boot = true
  join_server = "infra-server-01.kellerhome.us"
  pve_node = "prox2"
  clone_image  = "ubuntu-cloudimg-prox2"
  role = "server"
  primary = false

  storage_size = "500G"
  storage_type = "ssdpoolprox2"
  memory = 32768
  cpus = 8

  ip_addr = "192.168.1.24"
  node_host = "infra-server-03"
  cluster_host = "infra"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

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

module "dev-node-01" {
  source = "../modules/dev-node"

  name = "dev-01.kellerhome.us"
  pve_node = "pve"
  clone_image  = "ubuntu-cloudimg-prox"

  storage_size = "60G"
  storage_type = "ssdpool2"
  memory = 32768
  cpus = 8

  ip_addr = "192.168.1.60"
  nameservers = "192.168.0.130"
  password = var.password

}