# Starting from Scratch

For me, I'm using this repository as a record for refreshing my homelab. But it can just as easily be used as a reference for someone beginning their homelab from scratch.

## Considerations

A great start to your homelab infrastructure and its organization is to document, document, DOCUMENT.

Thinking about primary goals such as:
- A "stable" environment to serve long-lived workloads
    - For me, this is planned to be Kubenretes via RKE2
- Ehpemeral instances to serve as easy testing spaces
    - Standard Ubuntu server Image
- Redundancy/Support Services
    - Backup location with disks in a redudnant configuration
    - NFS/S3-compliant
    - DNS server