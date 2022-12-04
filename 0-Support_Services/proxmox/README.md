# Proxmox Notes

- Request certificate w/ certbot

- Update proxmox iptables to redirect 433 to 8006
```
/sbin/iptables -F
/sbin/iptables -t nat -F
/sbin/iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 8006
```