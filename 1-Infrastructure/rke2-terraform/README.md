# rke2-terraform
This is intended to be a spin on the rke2 terraform that exists for cloud providers. Intent here is to provide an example for on-premise installations that can provision (and scale) clusters with nodes that are cattle and not pets.

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

## Dependencies
- DNS
- Loadbalancing for highly-available clusters

## TODO
- add machine configurations for Big Bang