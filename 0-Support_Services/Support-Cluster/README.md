# Support Cluster

Provides a kubernetes cluster and services deployed therein to support other downstream clusters.

## Target
This is planned to target a desktop server that has a RAID volume of multiple disks for redundancy.

## Questions
- Should this remain a single server? or could this be the first of a larger cluster?

## Goals/Objectives
- Dogfood Zarf
- RKE2 distrobution
- Flux
- Big Bang
    - Istio
        - Needs a certificate - generate with cert-bot and dns-01 challenge
        - `*.support.kellerhome.us`
    - Monitoring
    - Logging
    - Minio Operator / Minio
        - Look into [Minio Operator requirements](https://github.com/minio/operator/blob/master/README.md)
        - Use a large portion of the Raid-array
    - Nexus
        - Establish docker proxies for docker hub and Registry 1
    - Cert-Manager (Not Required Initially)
- Flux terraform controller