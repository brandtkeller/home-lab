# HomeLab Upgrade

Time to consider a homelab renovation. There is a lot of infrastructure sprawl due to experimentation that would be great to aggregate into a single manageable system. 

## Requirements
- One Cluster to rule them all
- Let's get supporting infrastructure right this time.
  - IS it worth looking at a dedicated NAS/NFS?
  - Syncthing infra requirements?
- Kubernetes Cluster
  - 3 server nodes
  - 2 agent nodes
  - Talos Linux?
  - Longhorn?
    - Backup connected to NFS
- Consideration for which subnet this should all live on?
  - 1 subnet for work
    - 2 Machines + Wifi
  - 1 subnet for all other experimentation
- Bring the Blog into the primary cluster
  - flux to manage the blog
- Setup Cloudflared-tunnel to a wildcard DNS entry
  - Open external access to apps

