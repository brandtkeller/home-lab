# Support Services

This will outline the plan and catalog the current state of support services.

## Services
- On-premise Loadbalancer
- ansible

## Plan
- Create a Support Services Node
    - This will act as both a jump-box where zarf executes from as well as the host for the loadbalancer server 
    - Should this be a dedicated machine? what other purposes could this serve?
- Zarf
    - Package Pre-reqs
        - Pull nginx/ansible image to local filesystem (as archives)
        - Declare those images as file resources
        - Create service definition files and declare them as file reosurces
    - Deploy    
        - `podman load` the images
        - Load service defintion files into systemd