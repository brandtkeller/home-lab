# Infrastructure

This document will outline the plan to establish and update infrastructure.

## Cattle-not-Pets (CnP)
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
- https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu
- https://github.com/Telmate/terraform-provider-proxmox
- https://www.terraform.io/language/modules/develop

## Highly Available cluster w/ ability to upgrade OS/Kubernetes version via CnP

### Cluster Initialization

- "Bootstrap" server node is established as the first cluster node
    - Default nameserver configuration
    - Comes online
    - Deploy DNS daemonset (to worker nodes)
        - Entries
            - k8s.kellerhome.us
            - *.k8s.kellerhome.us
            - k8s-server-01.kellerhome.us
            - ...
    - Deploy Loadbalancer daemonset (to worker nodes)
        - Entries
            - 6443
            - 9345
            - 443
            - 80
- Deploy second server
    - Nameserver = IP of bootstrap
    - server = https://k8s.home.local:9345
    - Comes online
    - Ensure daemonset scales
- Deploy third server
    - Nameserver = IP of second server
    - server = https://k8s.home.local:9345
    - Comes online
    - Ensure daemonset scales
- Remove bootstrap node & deploy new first server
    - Drain/cordon node
    - De-provision
    - Provisioner new node
        - Nameserver = IP of third node
    - server = https://k8s.home.local:9345
    - Comes online
    - Ensure daemonset scales

### Cluster Upgrades
By not using a loop for the terraform, we can de-provision nodes singularly and update.

For each node
- Drain & cordon node
- Deprovision
- re-provision with explicit image template & kubernetes version

Rinse and repeat

