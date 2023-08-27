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
module "dev-zarf-test-1" {
  source = "../../modules/zarf-k3s-node"

  name = "dev-zarf-test-1"
  boot = true
  pve_node = "prox"
  clone_image  = "ubuntu-cloudimg-prox"

  join_server=""
  primary=true

  storage_size = "100G"
  storage_type = "local-lvm"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.61"
  nameservers = "8.8.8.8"
  password = var.password

}

module "dev-zarf-test-2" {
  source = "../../modules/zarf-k3s-node"

  name = "dev-zarf-test-2"
  boot = true
  pve_node = "prox"
  clone_image  = "ubuntu-cloudimg-prox"

  join_server="192.168.1.61"
  primary=false

  storage_size = "100G"
  storage_type = "local-lvm"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.62"
  nameservers = "8.8.8.8"
  password = var.password

  depends_on = [
    module.dev-zarf-test-1
  ]

}

module "dev-zarf-test-3" {
  source = "../../modules/zarf-k3s-node"

  name = "dev-zarf-test-3"
  boot = true
  pve_node = "prox"
  clone_image  = "ubuntu-cloudimg-prox"

  join_server="192.168.1.61"
  primary=false

  storage_size = "100G"
  storage_type = "local-lvm"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.63"
  nameservers = "8.8.8.8"
  password = var.password

  depends_on = [
    module.dev-zarf-test-1
  ]

}