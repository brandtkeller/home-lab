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

## Proxmox

### Valid Certificate Process
- Purchase domain
- Create Route53 hostedzone for domain name
    - Create A records for intended web traffic domains
- Use certbot to request a letsencrypt certificate using the `dns-route53` plugin
    - Use docker with the `--dns` flag to get-around the local dns resolution
- Questions:
    - Could I coordinate this locally?

### Ubuntu CloudImg

Establish script to run in cronjob that checks for the current cloudimg release hash in order to reduce how often a new image is downloaded. 