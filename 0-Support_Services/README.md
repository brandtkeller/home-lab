# Support Services

This will outline the plan and catalog the current state of support services.

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