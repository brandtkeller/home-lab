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
module "support-test-1" {
  source = "github.com/brandtkeller/proxmox-terraform-modules//dev-node"

  name = "dev-test-1"
  boot = true
  pve_node = "prox2"
  clone_image  = "ubuntu-cloudimg-prox2"

  storage_size = "100G"
  storage_type = "ssdpoolprox2"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.31"
  nameservers = "192.168.1.1"
  password = var.password

}
