# K8s Orchestration

This will outline the plan and catalog the current state.

## Plan

- Establish clusters separately from any resources that are provisioned.
- Perform a flux installation imperatively (this could be automated through manifests)
- Establish kustomization [bases](./bases/) for re-usable components
- Establish cluster [overlays](./clusters/) for specific clusters

## TODO
- Deployment of "stable" RKE2 cluster
    - Move state to Minio
    - Review deploying harbor for use as a proxy cache?
    - Photoprism deployment or Nextcloud
    - Velero setup
    - AWS minio copy to S3 cronjob
