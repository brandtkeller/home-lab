# Infrastructure

This document will outline the plan to establish and update infrastructure.

## Cattle-not-Pets
Having a plan for keeping infrastructure from becoming stale. Define a process for blue/green and updating underyling virtual machines and cluster as required to stay up-to-date.

### Blue/Green
What would this look like based on the services provided?


## Hardware
R710
- Purpose: Hosting long-lived kubernetes cluster - Provide no-cloud-cost dev environments for quick provision w/ terraform
- Storage
    - Raid 1 initialize 2x 1tb SSD's
    - Raid 10 initialize 4x 500gb SSD's
Ryzen Desktop
- Purpose: Host NFS server full-time - provide amd64 dev machine (can host multiple k3d clusters)
- Storage
    - 2x 4tb btrfs raid1 array
Raspberry Pi 4 - 4gb
- Purpose: Hosts DNS server via CoreDNS

## Directories
- [dev-terraform](./dev-terraform/README.md)
    - Captures quick-spinup linux VM's for amd64 development projects
- [rke2-terraform](./rke2-terraform/README.md)
    - Captures cluster configurations for the home "stable" cluster

## Plan
- Host DNS server on Raspberry pi (until this can be co-located with required workloads)
    - Analyze current configuration and systemctl entries
    - Anisible script for reproducible configuration

Relevant Content:
- https://pve.proxmox.com/wiki/Cloud-Init_Support
- https://github.com/Telmate/terraform-provider-proxmox
- https://www.terraform.io/language/modules/develop