#!/bin/bash

# Install Go 1.19
echo "Installing Go"
curl -LO https://go.dev/dl/go1.19.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.linux-amd64.tar.gz
rm go1.19.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> /home/dev/.bashrc


# Clone Zarf
git clone https://github.com/defenseunicorns/zarf.git

