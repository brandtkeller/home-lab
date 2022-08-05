# K8s Infrastructure
This will outline the plan and catalog the current state.

## Plan
- https://github.com/willhallonline/docker-ansible <- Ansible docker image?
- Playbook for pre-kubernetes configuration of VM's
    - 3x Server Node VM
    - 3x Agent Node VM's
- Playbook for RKE2 installation
    - Include OpenEBS installation
        - JIVA for replication
    - Include NFS dynamic provisioner
    - Disable Metrics-Server