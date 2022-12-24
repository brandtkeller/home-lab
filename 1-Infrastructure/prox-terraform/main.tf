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

module "infra-server-purple" {
  source = "../modules/rke2-node"

  name = "infra-server-purple.kellerhome.us"
  boot = true
  join_server = "infra-server-green.kellerhome.us"
  pve_node = "pve"
  clone_image  = "ubuntu-cloudimg-prox"
  role = "server"
  primary = false

  storage_size = "100G"
  storage_type = "ssdpool2"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.22"
  node_host = "infra-server-purple"
  cluster_host = "infra"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

}

module "infra-server-blue" {
  source = "../modules/rke2-node"

  name = "infra-server-blue.kellerhome.us"
  boot = true
  join_server = "infra-server-green.kellerhome.us"
  pve_node = "prox2"
  clone_image  = "ubuntu-cloudimg-prox2"
  role = "server"
  primary = false

  storage_size = "100G"
  storage_type = "ssdpoolprox2"
  memory = 16384
  cpus = 8

  ip_addr = "192.168.1.24"
  node_host = "infra-server-03"
  cluster_host = "infra"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

}

module "infra-server-green" {
  source = "../modules/rke2-node"

  name = "infra-server-green.kellerhome.us"
  boot = true
  join_server = "infra-server-blue.kellerhome.us"
  pve_node = "pve"
  clone_image  = "ubuntu-cloudimg-prox"
  role = "server"
  primary = false

  storage_size = "100G"
  storage_type = "ssdpool2"
  memory = 16384
  cpus = 8

  ip_addr = "192.168.1.25"
  node_host = "infra-server-green"
  cluster_host = "infra"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

}

module "infra-agent-green" {
  source = "../modules/rke2-node"

  name = "infra-agent-green.kellerhome.us"
  boot = true
  join_server = "infra-server-green.kellerhome.us"
  pve_node = "pve"
  clone_image  = "ubuntu-cloudimg-prox"
  role = "agent"
  primary = false

  storage_size = "500G"
  storage_type = "ssdpool2"
  memory = 32768
  cpus = 8

  ip_addr = "192.168.1.26"
  node_host = "infra-agent-green"
  cluster_host = "infra"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

}

module "infra-agent-purple" {
  source = "../modules/rke2-node"

  name = "infra-agent-purple.kellerhome.us"
  boot = true
  join_server = "infra-server-green.kellerhome.us"
  pve_node = "pve"
  clone_image  = "ubuntu-cloudimg-prox"
  role = "agent"
  primary = false

  storage_size = "500G"
  storage_type = "ssdpool2"
  memory = 32768
  cpus = 8

  ip_addr = "192.168.1.27"
  node_host = "infra-agent-purple"
  cluster_host = "infra"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

}

module "infra-agent-blue" {
  source = "../modules/rke2-node"

  name = "infra-agent-blue.kellerhome.us"
  boot = true
  join_server = "infra-server-green.kellerhome.us"
  pve_node = "prox2"
  clone_image  = "ubuntu-cloudimg-prox2"
  role = "agent"
  primary = false

  storage_size = "500G"
  storage_type = "ssdpoolprox2"
  memory = 16384
  cpus = 8

  ip_addr = "192.168.1.28"
  node_host = "infra-agent-blue"
  cluster_host = "infra"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

}


# module "dev-node-01" {
#   source = "../modules/dev-node"

#   name = "dev-01.kellerhome.us"
#   pve_node = "pve"
#   clone_image  = "ubuntu-cloudimg-prox"

#   storage_size = "60G"
#   storage_type = "ssdpool2"
#   memory = 32768
#   cpus = 8

#   ip_addr = "192.168.1.60"
#   nameservers = "192.168.0.130"
#   password = var.password

# }