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
    - 
- TODO:
    - Create and apply a sops GPG key into secret
    - Create directory structure under `2-Orchestration/clusters/infrastructure` for flux reconiliation of source
        - Extend the base to include storage (could just be a helm release?)
            - helm release in a `/storage` base
            

