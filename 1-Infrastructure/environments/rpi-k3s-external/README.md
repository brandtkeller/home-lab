# RPI K3S Cluster

```
cp k3s-arm64 /usr/local/bin/k3s
chmod +x /usr/local/bin/k3s
mkdir -p /var/lib/rancher/k3s/agent/images/
mkdir -p /etc/rancher/k3s/
cp k3s-airgap-images-arm64.tar.zst /var/lib/rancher/k3s/agent/images/
cp primary-config.yaml /etc/rancher/k3s/config.yaml
INSTALL_K3S_SKIP_DOWNLOAD=true INSTALL_K3S_EXEC='server' sh /root/k3s-external/install.sh
```