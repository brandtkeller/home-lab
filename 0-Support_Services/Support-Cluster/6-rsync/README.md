# Rsync in-cluster

## How to use a private-key for ssh authentication
rsync -av -e 'ssh -i nopass' /data/data/brandtkeller/ dev@192.168.1.15:/data/nextcloud/brandtkeller