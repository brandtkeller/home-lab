#!/bin/bash

set -e

# Check for an updated cloudimg hash
rm SHA256SUMS* || echo "no existing sums to delete"
wget https://cloud-images.ubuntu.com/jammy/current/SHA256SUMS
LATEST_SHA=$(cat SHA256SUMS | grep "jammy-server-cloudimg-amd64.img" | cut -d " " -f 1)
CUR_SHA=$(sha256sum jammy-server-cloudimg-amd64.img | cut -d " " -f 1)
DATE=$(date)

echo "${DATE} - Checking for updates"

if [ $LATEST_SHA == $CUR_SHA ]; then
    echo "Image is latest - no download required"
else
    # Rename previous image and get latest image
    rm jammy-server-cloudimg-amd64.img.old || echo "No old image to delete"
    mv jammy-server-cloudimg-amd64.img jammy-server-cloudimg-amd64.img.old

    echo "Downloading the new cloudimg"
    wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

    # Get oldid and set newid
    oldid=$(cat ./id || echo "9000")
    newid=$((${oldid} + 1))
    # change name to prevent conflict (does this matter?)
    echo "Renaming template $oldid"
    qm set $oldid --name old-ubuntu-cloudimg

    echo "Starting creation of the new template"
    qm create $newid --memory 2048 --net0 virtio,bridge=vmbr1
    qm importdisk $newid jammy-server-cloudimg-amd64.img ssdpool1
    qm set $newid --scsihw virtio-scsi-pci --scsi0 ssdpool1:$newid/vm-$newid-disk-0.raw
    qm set $newid --ide2 ssdpool1:cloudinit
    qm set $newid --boot c --bootdisk scsi0
    qm set $newid --serial0 socket --vga serial0
    qm template $newid
    qm set $newid --name ubuntu-cloudimg

    echo "New template created - id = $newid"

    echo "$newid" > ./id

    echo "Removing oldest vm"
    qm destroy $((${oldid} - 1)) || exit 0
fi

