#!/bin/bash

VERSION=v1.25.4%2Brke2r1

cd ../modules/rke2-node/files/artifacts/

declare -a artifacts=(
    "https://github.com/rancher/rke2/releases/download/${VERSION}/rke2-images.linux-amd64.tar.zst"
    "https://github.com/rancher/rke2/releases/download/${VERSION}/rke2.linux-amd64.tar.gz"
    "https://github.com/rancher/rke2/releases/download/${VERSION}/sha256sum-amd64.txt"
)

for val in ${artifacts[@]}; do
   curl -LO $val
done
