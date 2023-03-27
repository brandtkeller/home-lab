#!/bin/bash

STORAGE=local-lvm
NODE=prox
SECONDARY=""
isPrimary=true

set -e

function create_template() {
    # Get oldid and set newid
    oldid=$(cat ./id || echo "9000")
    newid=$((${oldid} + 1))
    # change name to prevent conflict (does this matter?)
    echo "Renaming template $oldid"
    qm set $oldid --name old-ubuntu-cloudimg-$NODE || echo "template does not exist"

    echo "Starting creation of the new template"
    qm create $newid --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci
    qm set $newid --scsi0 $STORAGE:0,import-from=/root/jammy-server-cloudimg-amd64.img
    qm set $newid --ide2 $STORAGE:cloudinit
    qm set $newid --boot c --bootdisk scsi0
    qm set $newid --serial0 socket --vga serial0
    qm template $newid
    qm set $newid --name ubuntu-cloudimg-$NODE

    echo "New template created - id = $newid"

    echo "$newid" > ./id

    echo "Removing oldest vm"
    qm destroy $((${oldid} - 1)) || exit 0
}


if $isPrimary ; then
    # Check for an updated cloudimg hash
    rm SHA256SUMS* || echo "no existing sums to delete"
    wget https://cloud-images.ubuntu.com/jammy/current/SHA256SUMS
    LATEST_SHA=$(cat SHA256SUMS | grep "jammy-server-cloudimg-amd64.img" | cut -d " " -f 1)
    CUR_SHA=$(sha256sum jammy-server-cloudimg-amd64.img | cut -d " " -f 1 || echo "")
    DATE=$(date)

    echo "${DATE} - Checking for updates"
    if [ $LATEST_SHA == $CUR_SHA ]; then
        echo "Image is latest - no download required"
    else
        # Rename previous image and get latest image
        rm jammy-server-cloudimg-amd64.img.old || echo "No old image to delete"
        mv jammy-server-cloudimg-amd64.img jammy-server-cloudimg-amd64.img.old || echo "no present image to archive"

        echo "Downloading the new cloudimg"
        wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

        if [ $SECONDARY != "" ]; then
            scp jammy-server-cloudimg-amd64.img root@$SECONDARY:/root/jammy-server-cloudimg-amd64.img.new
            ssh root@$SECONDARY 'nohup /root/update.sh </dev/null >update.log 2>&1' &
        fi

        create_template
    fi
else 
    rm jammy-server-cloudimg-amd64.img.old || echo "No old image to delete"
    mv jammy-server-cloudimg-amd64.img jammy-server-cloudimg-amd64.img.old || echo "No image to backup"
    mv jammy-server-cloudimg-amd64.img.new jammy-server-cloudimg-amd64.img

    create_template
fi