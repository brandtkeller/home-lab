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
# module "zarf-test-1" {
#   source = "../../modules/zarf-k3s-node"

#   name = "zarf-test-1.kellerhome.us"
#   boot = true
#   pve_node = "prox"
#   clone_image  = "ubuntu-cloudimg-prox"
  
#   join_server = ""
#   primary = true
  
#   zarf_command = "sudo zarf package deploy zarf-init-amd64-v0.29.1.tar.zst --components=k3s,zarf-injector,zarf-seed-registry,zarf-registry,zarf-agent,git-server --confirm"

#   storage_size = "100G"
#   storage_type = "local-lvm"
#   memory = 16384
#   cpus = 4

#   ip_addr = "192.168.1.81"
#   nameservers = "192.168.0.130"
#   password = var.password

# }

module "zarf-test-upgrade" {
  source = "../../modules/zarf-k3s-node"

  name = "zarf-test-1.kellerhome.us"
  boot = true
  pve_node = "prox"
  clone_image  = "ubuntu-cloudimg-prox"
  
  join_server = ""
  primary = true
  
  zarf_command = "sudo zarf package deploy zarf-init-amd64-v0.27.1.tar.zst --components=k3s,zarf-injector,zarf-seed-registry,zarf-registry,zarf-agent,git-server --confirm"

  storage_size = "100G"
  storage_type = "local-lvm"
  memory = 16384
  cpus = 4

  ip_addr = "192.168.1.82"
  nameservers = "192.168.0.130"
  password = var.password

}