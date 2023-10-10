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


module "k8s-home-4" {
  source = "github.com/brandtkeller/proxmox-terraform-modules//rke2-node"

  name = "k8s-home-4.kellerhome.us"
  boot = true
  join_server = "192.168.0.42"
  pve_node = "prox"
  clone_image  = "ubuntu-cloudimg-prox"
  
  rke2_arch = "amd64"
  role = "agent"
  primary = false
  taint = false

  storage_size = "400G"
  storage_type = "local-lvm"
  memory = 32768
  cpus = 8

  ip_addr = "192.168.1.44"
  node_host = "k8s-home-4"
  cluster_host = "home"
  domain = "kellerhome.us"
  nameservers = "192.168.1.1"
  password = var.password

}

module "k8s-home-5" {
  source = "github.com/brandtkeller/proxmox-terraform-modules//rke2-node"

  name = "k8s-home-5.kellerhome.us"
  boot = true
  join_server = "192.168.0.42"
  pve_node = "prox"
  clone_image  = "ubuntu-cloudimg-prox"
  
  rke2_arch = "amd64"
  role = "agent"
  primary = false
  taint = false

  storage_size = "400G"
  storage_type = "local-lvm"
  memory = 32768
  cpus = 8

  ip_addr = "192.168.1.45"
  node_host = "k8s-home-5"
  cluster_host = "home"
  domain = "kellerhome.us"
  nameservers = "192.168.1.1"
  password = var.password

}