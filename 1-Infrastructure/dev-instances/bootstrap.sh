#!/bin/bash

# install zarf
curl -LO https://github.com/defenseunicorns/zarf/releases/download/v0.29.0/zarf_v0.29.0_Linux_amd64
sudo mv zarf_v0.29.0_Linux_amd64 /usr/bin/zarf && chmod +x /usr/bin/zarf

# kernel restart supression?
sudo sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf
sudo sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/g" /etc/needrestart/needrestart.conf

# longhorn deps
sudo apt install -y nfs-common
sudo systemctl enable iscsid && sudo systemctl start iscsid