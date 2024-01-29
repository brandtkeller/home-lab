# Infrastructure

This document will outline the plan to establish and update infrastructure.

## Cattle-not-Pets (CnP)
Having a plan for keeping infrastructure from becoming stale. Define a process for blue/green and updating underlying virtual machines and cluster as required to stay up-to-date.

### Blue/Green
What would this look like based on the services provided?


## Hardware
R720
- Purpose: Hosting long-lived kubernetes cluster - Provide no-cloud-cost dev environments for quick provision w/ terraform
- Storage
    - 2x 4tb btrfs raid1 array
    - Raid 10 initialize 4x 500gb SSD's
Ryzen Desktop
- Purpose: Host NFS server full-time - provide amd64 dev machine (can host multiple k3d clusters)
- Storage
    - Raid 1 initialize 2x 1tb SSD's

Raspberry Pi 4 - 4gb
- Purpose: Hosts DNS server via CoreDNS

## Directories
- [dev-terraform](./dev-terraform/README.md)
    - Captures quick-spinup linux VM's for amd64 development projects
- [prox-terraform](./prox-terraform/README.md)
    - Captures cluster configurations for the home "stable" cluster

Relevant Content:
- https://pve.proxmox.com/wiki/Cloud-Init_Support
- https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu
- https://github.com/Telmate/terraform-provider-proxmox
- https://www.terraform.io/language/modules/develop

## Highly Available cluster w/ ability to upgrade OS/Kubernetes version via CnP

### Cluster Upgrades
By not using a loop for the terraform, we can de-provision nodes singularly and update.

For each node
- Drain & cordon node
- Deprovision
- Re-provision with explicit image template & kubernetes version

Rinse and repeat

Through the use of replication through the Jiva-Operator of OpenEBS - we should be able to drain/cordon a node, deprovision and re-provision with an updated version of OS or Kubernetes and re-establish workloads with persistent storage.
