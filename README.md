# Home Infrastructure
A catalog of the current and planned state for my Home Lab.

I wanted to document and catalog the updates to my home lab for multiple reasons:
- Assist in capturing plans for modifications to the hardware and identify dependencies. 
- Provide a space for documenting what is deployed and how.
- Ensure all configurations are either declarative or idempotent - such that this can evolve over time.

## Work In-progress
- DNS Configuration-as-Code
  - TODO:
    - Wipe RPI and install latest image of raspbian
    - K8s or Ansible?
    - CaC
- Deployment of "stable" RKE2 cluster
  - TODO:
    - Add an "additional manifests" directory under files
    - Template vip.yaml file?
    - Address storage plans - is this a post-flux installation?


