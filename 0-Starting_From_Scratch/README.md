# Starting from Scratch

Catalog what needs to be done before tearing down the existing setup and starting from scratch.

## Data Backup Plans
- Ensure access and availability to S3 storage for backed-up data
- Create backup copy by mounting external harddrive to the backup raid array and creating another copy
- Capture the current state of the Core Services Node
    - Just need the state captured for a point-in-time
        - This will be used later in [2-Support_Services](../2-Support_Services/README.md)
        - Load-Balancer configruations
        - NFS Server configurations