# Dev-terraform

Terraform to quickly spin-up dev VM's on the home proxmox machine

## Proxmox Authentication
Must export environment variables to use:
```
export PM_USER="terraform-prov@pve"
export PM_PASS="password"
```

## TO DO
- Create proxmox script that runs daily to pull latest ubuntu cloudimg and convert to template named "ubuntu-cloudimg"
