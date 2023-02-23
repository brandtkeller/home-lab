# List of items to do

## Maintenance

- Separate instances of proxmox
- Upgrade Big Bang - Renovate?
- Rsync Cronjob chart to redundant storage (Onsite-Backup)
- velero configuration to S3 (Offsite-Backup)
- Fix any exceptions required for Kyverno/Nextcloud
- Integrate Nextcloud to be a first-class Big Bang application
- Cert-manager to keep certificates automatically up-to-date

## Primary Cluster
Ideal hardware
1x Ryzen Desktop (already have)
2x Ryzen minipc's

Ryzen Desktop
- Proxmox OS
    - pfsense(?) VM
        - 2 CPU / 8gb Memory
        - 2.5Gbe card passthrough
    - Infrastructure Node - K3s Worker
        - Should this be a single node cluster? Or a worker node with a label?
            - attached the to primary stable cluster means more efficient use of resources 
        - 4 CPU / 8gb Memory
        - NFS w/ 2x4Tb disks
            - Move this workload to the ATX node
            - Enclosure required?
            - Ensure current stable cluster is associated
        - DNS
        - Image Proxy Cache
            - Should enable 2.5Gbe image pulls?
            - What kind of disk would be needed to support?
                - hostPath SSD?
    - K3s Server Node
        - 4 CPU / 8gb Memory

    - K3s Worker Node
        - 8 CPU / 32gb Memory

Ryzen MiniPC
- Proxmox OS
    - K3s Server Node
        - 4 CPU / 8gb Memory
    - K3s Server Node
        - 4 CPU / 8gb Memory
    - K3s Worker Node
        - 8 CPU / 32gb Memory

## 2.5Gbe Network

### 2.5Gbe Initial Investment
- Multi-port network card for Desktop
- Adapter for Mac
- pfsense in proxmox VM

### 2.5Gbe Extension
- 2.5Gbe Switch - 8 port
