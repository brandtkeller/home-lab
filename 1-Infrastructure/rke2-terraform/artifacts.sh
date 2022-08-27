#!/bin/bash

VERSION=v1.24.3%2Brke2r1

declare -a artifacts=(
    "https://github.com/rancher/rke2/releases/download/${VERSION}/rke2-images.linux-amd64.tar.zst"
    "https://github.com/rancher/rke2/releases/download/${VERSION}/rke2.linux-amd64.tar.gz"
    "https://github.com/rancher/rke2/releases/download/${VERSION}/sha256sum-amd64.txt"
)

for val in ${artifacts[@]}; do
   curl -LO $val
done

