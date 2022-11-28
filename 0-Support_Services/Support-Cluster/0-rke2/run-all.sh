#!/bin/bash

VERSION=v1.25.4%2Brke2r1
DOWNLOAD=true

if [ "$DOWNLOAD" = true ] ; then
    mkdir artifacts && cd artifacts

    declare -a artifacts=(
    "https://github.com/rancher/rke2/releases/download/${VERSION}/rke2-images.linux-amd64.tar.zst"
    "https://github.com/rancher/rke2/releases/download/${VERSION}/rke2.linux-amd64.tar.gz"
    "https://github.com/rancher/rke2/releases/download/${VERSION}/sha256sum-amd64.txt"
    )

    for val in ${artifacts[@]}; do
        curl -LO $val
    done
    cd ..
fi

sudo mkdir -p /etc/rancher/rke2
sudo cp config.yaml /etc/rancher/rke2/config.yaml
sudo cp manifests/* /var/lib/rancher/rke2/server/manifests
sudo INSTALL_RKE2_ARTIFACT_PATH=/home/dev/rke2/artifacts sh /home/dev/rke2/install.sh
sudo systemctl enable rke2-server.service
sudo systemctl start rke2-server.service
