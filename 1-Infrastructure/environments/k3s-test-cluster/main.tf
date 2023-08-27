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
module "k3s-test-1" {
  source = "../../modules/k3s-node"

  name = "k3s-test-1.kellerhome.us"
  boot = true
  join_server = ""
  pve_node = "prox"
  clone_image  = "ubuntu-cloudimg-prox"
  role = "server"
  primary = true
  taint = false

  storage_size = "100G"
  storage_type = "local-lvm"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.72"
  node_host = "k3s-test-1"
  cluster_host = "test"
  domain = "kellerhome.us"
  nameservers = "192.168.0.130"
  password = var.password

}
