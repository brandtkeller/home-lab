#!/bin/bash

sudo mkdir -p /etc/rancher/rke2

sudo cp /home/dev/config.yaml /etc/rancher/rke2/config.yaml

sudo INSTALL_RKE2_ARTIFACT_PATH=/home/dev/rke2-artifacts sh /home/dev/rke2-artifacts/install.sh

sudo systemctl enable rke2-server.service

sudo systemctl start rke2-server.service