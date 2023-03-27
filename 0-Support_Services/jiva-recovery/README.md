# Jiva Recovery

How to recover data from the node in the location where jiva stores the persistent data

- Find an image that has rsync or another copy utility
    - `brandtkeller/rsync:8.7`
- Create PVC's for the data to be recovered
- Copy the data from NFS to the node directory for jiva data
- start nextcloud with replicas and postgresql replicas = 0
- create a pod that mounts the existing PVC's and rsyncs the data


