# Home Infrastructure
A catalog of the current and planned state for my Home Lab.

I wanted to document and catalog the updates to my home lab for multiple reasons:
- Assist in capturing plans for modifications to the hardware and identify dependencies. 
- Provide a space for documenting what is deployed and how.
- Ensure all configurations are either declarative or idempotent - such that this can evolve over time.

## Hardware 
The hardware I currently have:
- Dell R710
  - 120gb Memory, 1TB SSD, 2x 8 core 3GHz Processors, HBA card
- Netapp Disk Shelf
  - 13 x 2TB HDD
- 2x RPI 4 4GB

## High Level Plan
Major parts of this refresh include:
- Additional hardware components for resiliency
  - 2x 1TB SSD for primary node storage
- Updating Hypervisor OS and configuration
  - Latest Proxmox
- Domain and certificate information
- DNS server / NFS server / Loadbalancer Configuration as Code
- VM Configuration as Code
- Kubernetes deployment (RKE2) Configuration as Code
  - OpenEBS storage (primary)
  - NFS storage
- Kubernetes application configuration w/ Zarf
  - Big Bang Core
  - Nextcloud (Or other photo application?)
    - Syncing to S3
  - Calibre
  - Valheim

