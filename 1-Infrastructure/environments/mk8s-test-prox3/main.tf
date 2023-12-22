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


# prox3 Hosts
module "mk8s-test-1" {
  source = "github.com/brandtkeller/proxmox-terraform-modules//dev-node"

  name = "mk8s-test-1"
  boot = true
  pve_node = "prox3"
  clone_image  = "ubuntu-cloudimg-prox3"

  storage_size = "100G"
  storage_type = "ssdpoolprox3"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.71"
  nameservers = "192.168.1.1"
  password = var.password

}

# prox3 Hosts
module "mk8s-test-2" {
  source = "github.com/brandtkeller/proxmox-terraform-modules//dev-node"

  name = "mk8s-test-2"
  boot = true
  pve_node = "prox3"
  clone_image  = "ubuntu-cloudimg-prox3"

  storage_size = "100G"
  storage_type = "ssdpoolprox3"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.72"
  nameservers = "192.168.1.1"
  password = var.password

}

# prox3 Hosts
module "mk8s-test-3" {
  source = "github.com/brandtkeller/proxmox-terraform-modules//dev-node"

  name = "mk8s-test-3"
  boot = true
  pve_node = "prox3"
  clone_image  = "ubuntu-cloudimg-prox3"

  storage_size = "100G"
  storage_type = "ssdpoolprox3"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.73"
  nameservers = "192.168.1.1"
  password = var.password

}

# prox3 Hosts
module "mk8s-test-4" {
  source = "github.com/brandtkeller/proxmox-terraform-modules//dev-node"

  name = "mk8s-test-4"
  boot = true
  pve_node = "prox3"
  clone_image  = "ubuntu-cloudimg-prox3"

  storage_size = "100G"
  storage_type = "ssdpoolprox3"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.74"
  nameservers = "192.168.1.1"
  password = var.password

  depends_on = [
    module.mk8s-test-1
  ]

}

# prox3 Hosts
module "mk8s-test-5" {
  source = "github.com/brandtkeller/proxmox-terraform-modules//dev-node"

  name = "mk8s-test-5"
  boot = true
  pve_node = "prox3"
  clone_image  = "ubuntu-cloudimg-prox3"

  storage_size = "100G"
  storage_type = "ssdpoolprox3"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.75"
  nameservers = "192.168.1.1"
  password = var.password

  depends_on = [
    module.mk8s-test-1
  ]

}

# prox3 Hosts
module "mk8s-test-6" {
  source = "github.com/brandtkeller/proxmox-terraform-modules//dev-node"

  name = "mk8s-test-6"
  boot = true
  pve_node = "prox3"
  clone_image  = "ubuntu-cloudimg-prox3"

  storage_size = "100G"
  storage_type = "ssdpoolprox3"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.76"
  nameservers = "192.168.1.1"
  password = var.password

  depends_on = [
    module.mk8s-test-1
  ]

}