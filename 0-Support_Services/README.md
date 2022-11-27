# Support Services

This will outline the plan and catalog the current state of support services.

## DNS

### Target
Raspberry Pi 4 - 4GB

### Goals/Objectives and Execution
- Add `cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1` to end of `/boot/cmdline.txt` and reboot
- Run `ssh-copy-id -i <publickey> pi@<IP>`
- Run `k3sup install --ip <IP> --user pi --ssh-key <priv key> --no-extras`from remote host
    - If this fails and you get it running on the PI, you can use `k3sup install --ip <IP> --user pi --ssh-key <priv key> --no-extras --skip-install` to get the kubeconfig
- Create DNS manifests
    - DaemonSet - Allowing for automatic scaling as additional nodes are added to cluster (Maybe Future Enhancement)
    - ConfigMap - Configuration and Zone files
- Deploy and Test
    - `dig @<IP> infra.kellerhome.us`

## Support Cluster

Provides a kubernetes cluster and services deployed therein to support other downstream clusters.

### Target
This is planned to target a desktop server that has a RAID volume of multiple disks for redundancy.
- 8CPU/16 thread @3.9Ghz
- 32GB Memory @3200Mhz

### Questions
- Should this remain a single server? or could this be the first of a larger cluster?

### Valid Certificate Process
- Purchase domain
- Create Route53 hostedzone for domain name
    - Create A records for intended web traffic domains
- Use certbot to request a letsencrypt certificate using the `dns-route53` plugin
    - Use docker with the `--dns` flag to get-around the local dns resolution
- Questions:
    - Could I coordinate this locally?

### Goals/Objectives
- RKE2 distribution
    - repeatable install w/o ansible
- Storage Class
    - Local-path-provisioner
        - Zarf requires a storage class - will need to deploy this before zarf
        - TODO - Evaluate pre-loading this with RKE2 in some fashion to prevent modification of Zarf constraints
- Zarf
    - Init w/ `v0.22.2`
- Kube-VIP
    - VIP daemonset
    - Kube-VIP cloud controller manager
- Flux
- Big Bang
    - Istio
        - Needs a certificate - generate with cert-bot and dns-01 challenge
        - `*.infra.kellerhome.us`
    - Monitoring
    - Logging
    - Minio Operator / Minio
        - Look into [Minio Operator requirements](https://github.com/minio/operator/blob/master/README.md)
        - Use a large portion of the Raid-array
    - Nexus
        - Establish docker proxies for docker hub and Registry 1
    - Cert-Manager (Stretch Goal)
- Flux terraform controller