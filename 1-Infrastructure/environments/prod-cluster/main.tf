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


# prox2 Hosts
# module "prod-server-orange" {
#   source = "../modules/rke2-node"

#   name = "prod-server-orange.kellerhome.us"
#   boot = true
#   join_server = ""
#   pve_node = "prox2"
#   clone_image  = "ubuntu-cloudimg-prox2"
#   role = "server"
#   primary = true
#   taint = true

#   storage_size = "100G"
#   storage_type = "ssdpoolprox2"
#   memory = 16384
#   cpus = 4

#   ip_addr = "192.168.1.34"
#   node_host = "prod-server-orange"
#   cluster_host = "prod"
#   domain = "kellerhome.us"
#   nameservers = "192.168.0.130"
#   password = var.password

# }

# module "prod-agent-orange" {
#   source = "../modules/rke2-node"

#   name = "prod-agent-orange.kellerhome.us"
#   boot = false
#   join_server = "prod-server-orange.kellerhome.us"
#   pve_node = "prox2"
#   clone_image  = "ubuntu-cloudimg-prox2"
#   role = "agent"
#   primary = false
#   taint = false

#   storage_size = "500G"
#   storage_type = "ssdpoolprox2"
#   memory = 32768
#   cpus = 8

#   ip_addr = "192.168.1.36"
#   node_host = "prod-agent-orange"
#   cluster_host = "prod"
#   domain = "kellerhome.us"
#   nameservers = "192.168.0.130"
#   password = var.password

# }

# ## Prox Hosts

# module "prod-server-red" {
#   source = "../modules/rke2-node"

#   name = "prod-server-red.kellerhome.us"
#   boot = true
#   join_server = "prod-server-orange.kellerhome.us"
#   pve_node = "prox"
#   clone_image  = "ubuntu-cloudimg-prox"
#   role = "server"
#   primary = false
#   taint = false

#   storage_size = "400G"
#   storage_type = "local-lvm"
#   memory = 32768
#   cpus = 8

#   ip_addr = "192.168.1.35"
#   node_host = "prod-server-red"
#   cluster_host = "prod"
#   domain = "kellerhome.us"
#   nameservers = "192.168.0.130"
#   password = var.password

# }

# module "prod-server-blue" {
#   source = "../modules/rke2-node"

#   name = "prod-server-blue.kellerhome.us"
#   boot = true
#   join_server = "prod-server-orange.kellerhome.us"
#   pve_node = "prox"
#   clone_image  = "ubuntu-cloudimg-prox"
#   role = "server"
#   primary = false
#   taint = false

#   storage_size = "400G"
#   storage_type = "local-lvm"
#   memory = 28672
#   cpus = 8

#   ip_addr = "192.168.1.33"
#   node_host = "prod-server-blue"
#   cluster_host = "prod"
#   domain = "kellerhome.us"
#   nameservers = "192.168.0.130"
#   password = var.password

# }
