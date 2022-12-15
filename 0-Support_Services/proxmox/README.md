# Proxmox Notes

- Request certificate w/ certbot

- Update proxmox iptables to redirect 433 to 8006
```
/sbin/iptables -F
/sbin/iptables -t nat -F
/sbin/iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 8006
```

## DISK setup

/dev/sda
/dev/sdd

mkfs.btrfs -L data -d raid1 -m raid1 -f /dev/sda /dev/sdd

929437c4-9111-412e-8d8b-acda5a53d521

UUID=f7414289-99f3-4a63-95c4-166f3e56154a /mnt/ssdpoolprox2  btrfs   defaults    0   0

fdisk /dev/sda

mkfs.ext4 /dev/sda1

/dev/sda1	/mnt/hddpool1	ext4	defaults     0   0
