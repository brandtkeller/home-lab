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
    - Infrastructure Node - RKE2 Worker
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
    - RKE2 Server Node
        - 4 CPU / 8gb Memory

    - RKE2 Worker Node
        - 8 CPU / 32gb Memory

Ryzen MiniPC
- Proxmox OS
    - RKE2 Server Node
        - 4 CPU / 8gb Memory
    - RKE2 Server Node
        - 4 CPU / 8gb Memory
    - RKE2 Worker Node
        - 8 CPU / 32gb Memory

## 2.5Gbe Network

### 2.5Gbe Initial Investment
- Multi-port network card for Desktop
- Adapter for Mac
- pfsense in proxmox VM

### 2.5Gbe Extension
- 2.5Gbe Switch - 8 port

# Home Lab Update 

Need to remove all VM's from node before joining it to a cluster
- Should be able to remove/reprovision the rke2 nodes with relative ease
- NFS is the core problem - Can I back this entire VM up to a separate location?
    - Hookup the 2TB external HDD
    - Backup the VM
    - scale the nextcloud deployment to 0 replicas
    - Delete the VM
    - Restore the VM
- If the above works, we can probably backup the current VM's, join the cluster and then restore them.

Longer term goal is to migrate workloads
- Change jiva configuration to 2x copies of data
- de-provision pve VM's
- Provision 2x rke2 server nodes on prox
- Provision 1x rke2 worker nodes on prox
- Once stable - re-provision prox2 nodes through TF

## Questions
- Do I want to make any changes to domains?