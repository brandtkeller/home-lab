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


# prox Hosts
module "k3s-databases-1" {
  source = "github.com/brandtkeller/proxmox-terraform-modules//k3s-node"

  name = "k3s-databases-1.kellerhome.us"
  boot = true
  pve_node = "prox2"
  clone_image  = "ubuntu-cloudimg-prox2"
  
  join_server = ""
  role = "server"
  primary = true
  k3s_arch = "amd64"
  taint = false
  

  storage_size = "200G"
  storage_type = "ssdpoolprox2"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.41"
  node_host = "k3s-databases-1"
  cluster_host = "home"
  domain = "kellerhome.us"
  nameservers = "192.168.1.1"
  password = var.password

}

# module "k3s-test-2" {
#   source = "github.com/brandtkeller/proxmox-terraform-modules//k3s-node"

#   name = "k3s-test-2.kellerhome.us"
#   boot = true
#   join_server = "192.168.1.72"
#   pve_node = "prox"
#   clone_image  = "ubuntu-cloudimg-prox"
#   role = "server"
#   k3s_arch = "amd64"
#   primary = false
#   taint = false

#   storage_size = "100G"
#   storage_type = "local-lvm"
#   memory = 16384
#   cpus = 4

#   ip_addr = "192.168.1.73"
#   node_host = "k3s-test-2"
#   cluster_host = "test"
#   domain = "kellerhome.us"
#   nameservers = "192.168.0.130"
#   password = var.password

#   depends_on = [
#     module.k3s-test-1
#   ]

# }

# module "k3s-test-3" {
#   source = "github.com/brandtkeller/proxmox-terraform-modules//k3s-node"

#   name = "k3s-test-3.kellerhome.us"
#   boot = true
#   join_server = "192.168.1.72"
#   pve_node = "prox"
#   clone_image  = "ubuntu-cloudimg-prox"
#   role = "server"
#   k3s_arch = "amd64"
#   primary = false
#   taint = false

#   storage_size = "100G"
#   storage_type = "local-lvm"
#   memory = 16384
#   cpus = 4

#   ip_addr = "192.168.1.74"
#   node_host = "k3s-test-3"
#   cluster_host = "test"
#   domain = "kellerhome.us"
#   nameservers = "192.168.0.130"
#   password = var.password

#   depends_on = [
#     module.k3s-test-1
#   ]

# }

# module "k3s-test-1-agent" {
#   source = "github.com/brandtkeller/proxmox-terraform-modules//k3s-node"

#   name = "k3s-test-1-agent.kellerhome.us"
#   boot = true
#   join_server = "192.168.1.72"
#   pve_node = "prox"
#   clone_image  = "ubuntu-cloudimg-prox"
  
#   k3s_arch = "amd64"
#   role = "agent"
#   primary = false
#   taint = false

#   storage_size = "100G"
#   storage_type = "local-lvm"
#   memory = 16384
#   cpus = 4

#   ip_addr = "192.168.1.75"
#   node_host = "k3s-test-1-agent"
#   cluster_host = "test"
#   domain = "kellerhome.us"
#   nameservers = "192.168.0.130"
#   password = var.password

#   depends_on = [
#     module.k3s-test-3
#   ]

# }