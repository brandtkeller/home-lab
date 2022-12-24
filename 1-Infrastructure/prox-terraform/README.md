# prox-terraform
This is intended to capture the live configuration of my proxmox development cluster (currently 2 physical machines). I will primarily use this to store 

## Structure

RKE2 can be installed well with the managed script and configured with the `config.yaml`.

Collecting the artifacts required for "air gap" installation will reduce download - reducing both network burden and duplication.
- Can we mount an NFS share for this? - Try doing so with the cloudimg

### Process
- Provision first master
    - Pull artifacts
    - Set token explicitly in config.yaml
- Place a `depends_on` block on servers 2 -> N and agents 1 -> N
    - https://www.terraform.io/language/meta-arguments/depends_on
- Execute provisioning remaining servers and agents






