#!/bin/bash

# kernel restart supression?
sudo sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf
sudo sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/g" /etc/needrestart/needrestart.conf

# # longhorn deps
# sudo apt install -y nfs-common
# sudo systemctl enable iscsid && sudo systemctl start iscsid

# sudo apt install -y make

# curl -LO https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
# sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
# export PATH=$PATH:/usr/local/go/bin
# go version

# git clone https://github.com/brandtkeller/mk8s.git

