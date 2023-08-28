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
module "rke2-test-1" {
  source = "github.com/brandtkeller/proxmox-terraform-modules//rke2-node"

  name = "rke2-test-1.kellerhome.us"
  boot = true
  pve_node = "prox"
  clone_image  = "ubuntu-cloudimg-prox"
  
  join_server = ""
  role = "server"
  primary = true
  rke2_arch = "amd64"
  taint = false
  

  storage_size = "100G"
  storage_type = "local-lvm"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.73"
  node_host = "rke2-test-1"
  cluster_host = "test"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

}

module "rke2-test-2" {
  source = "github.com/brandtkeller/proxmox-terraform-modules//rke2-node"

  name = "rke2-test-2.kellerhome.us"
  boot = true
  join_server = "192.168.1.73"
  pve_node = "prox"
  clone_image  = "ubuntu-cloudimg-prox"
  role = "server"
  rke2_arch = "amd64"
  primary = false
  taint = false

  storage_size = "100G"
  storage_type = "local-lvm"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.74"
  node_host = "rke2-test-2"
  cluster_host = "test"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

  depends_on = [
    module.rke2-test-1
  ]

}

module "rke2-test-3" {
  source = "github.com/brandtkeller/proxmox-terraform-modules//rke2-node"

  name = "rke2-test-3.kellerhome.us"
  boot = true
  join_server = "192.168.1.73"
  pve_node = "prox"
  clone_image  = "ubuntu-cloudimg-prox"
  role = "server"
  rke2_arch = "amd64"
  primary = false
  taint = false

  storage_size = "100G"
  storage_type = "local-lvm"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.75"
  node_host = "rke2-test-3"
  cluster_host = "test"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

  depends_on = [
    module.rke2-test-1
  ]

}

module "rke2-test-1-agent" {
  source = "github.com/brandtkeller/proxmox-terraform-modules//rke2-node"

  name = "k3s-test-1-agent.kellerhome.us"
  boot = true
  join_server = "192.168.1.73"
  pve_node = "prox"
  clone_image  = "ubuntu-cloudimg-prox"
  
  rke2_arch = "amd64"
  role = "agent"
  primary = false
  taint = false

  storage_size = "100G"
  storage_type = "local-lvm"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.76"
  node_host = "rke2-test-1-agent"
  cluster_host = "test"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

  depends_on = [
    module.rke2-test-3
  ]

}