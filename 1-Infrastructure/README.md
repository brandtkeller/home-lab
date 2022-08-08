# Infrastructure

This document will outline the plan and catalog current state of the infrastructure.

## Scope
- Installation of only REQUIRED tooling via package managers.
- Anything that can be packaged and installed with zarf should do so. Distro specific packages w/ complex dependencies can be baked into the base image.

## Plan

- Disk Health analysis - Review current raid arrays
- Install New SSD's
    - Raid 1 initialize 2x 1tb SSD's
    - Raid 10 initialize 4x 500gb SSD's
- Host NFS server from separate machine
    - 2x 4tb btrfs raid1 array
- Host DNS server on Raspberry pi (until this can be co-located with required workloads)
    - Analyze current configuration and systemctl entries
    - Anisible script for reproducible configuration

Terraform Usage:
- Add passwords to main.tf
    - Look at using an exported variable
- Add public ssh key to variables.tf
- terraform init 

Relevant Content:
- https://pve.proxmox.com/wiki/Cloud-Init_Support
- https://github.com/Telmate/terraform-provider-proxmox
- https://www.terraform.io/language/modules/develop