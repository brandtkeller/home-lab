# Raspberry Pi Cluster 

## Infrastructure
- 3x Raspberry Pi 4
- Gigabit switch

## Intent
Provide a lightweight (power consumption) kubernetes cluster for orchestration of services with lower resource demands.

## Requirements
- Add `cgroup_enable=memory cgroup_memory=1` to the end of `/boot/cmdline.txt`
- Unique Hostnames
- Create a unique token for cluster (replacing current stub)