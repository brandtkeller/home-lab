#!/bin/bash

# Install Go from https://go.dev/dl/
echo "Installing Go"
curl -LO https://go.dev/dl/go1.19.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.4.linux-amd64.tar.gz
rm go1.19.4.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> /home/dev/.bashrc