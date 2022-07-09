# Support Services

This will outline the plan and catalog the current state of support services.

## Services
- DNS server
- NFS server
- On-premise Loadbalancer
- ansible

## Plan
- Create a Support Services Node
    - This will act as both a jump-box where zarf executes from as well as the host for the loadbalancer and NFS server 
- Zarf
    - Package Pre-reqs
        - Pull nfs/nginx/ansible image to local filesystem (as archives)
        - Declare those images as file resources
        - Create service definition files and declare them as file reosurces
    - Deploy    
        - `podman load` the images
        - Load service defintion files into systemd
        - 