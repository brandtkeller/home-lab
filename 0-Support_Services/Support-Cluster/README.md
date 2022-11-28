# Support Services

This will outline the plan and catalog the current state of support services.

## DNS
- Target = RPI4
- Add `cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1` to end of `/boot/cmdline.txt` and reboot
- Run `ssh-copy-id -i <publickey> pi@<IP>`
- Run `k3sup install --ip <IP> --user pi --ssh-key <priv key> --no-extras`from remote host
    - If this fails and you get it running on the PI, you can use `k3sup install --ip <IP> --user pi --ssh-key <priv key> --no-extras --skip-install` to get the kubeconfig
- Create DNS manifest/configmap
- Deploy and Test
    - `dig @<IP> infra.kellerhome.us`

## Support Cluster
- Target = Ryzen 7 Desktop w/ 32gb Memory
- Setup:
    - 0-rke2 / Vanilla install via install.sh script using the airgap install method
    - 1-local-path / local path provisioner storage class - using public images currently
    - 2-zarf / zarf initialization 
    - 3-kube-vip / Kube VIP Zarf package w/ VIP daemonset and cloud controller manager
    - 4-certbot / Requesting `*.infra.kellerhome.us` certificates
    - 5-flux / Zarf packaged and deployed on its own
    - 6-big-bang / Big Bang Core zarf package w/ Minio & Nexus