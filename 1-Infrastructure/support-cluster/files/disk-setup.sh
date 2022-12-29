#!/bin/bash
# format
sudo mkfs -t ext4 /dev/sdb

# Get UUID
uuid=$(sudo blkid /dev/sdb | sed -n 's/.*UUID=\"\([^\"]*\)\".*/\1/p')

# Create fstab entry
sudo bash -c "echo 'UUID=${uuid}     /data       ext4   defaults' >> /etc/fstab"