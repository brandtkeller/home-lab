# Home Lab

### What is a Home Lab?
Machines and software that you run at home in order to learn new technologies and Host services that you and others within your LAN (Local Area Network) can use and rely upon without incurring the cost of cloud services.

### Where do you source equipment?
Check your local classifieds/ebay/etc. Beefy machines of 1-2 generations old can often be found for sale from entities that upgrade often. 

### What are your primary goals/objectives?
- First and foremost, established required services in a sustainable and reproducible fashion
- Second, Identify both "good" and "ideal" solutions - If "ideal" will consume 2x more time - execute with "good" first

### Why not shoot for "ideal"?
I focus on my daily work responsiblities without having to interact with this equipment often (Maybe I should change that in order to justify testing these services more). More often than not, I'll get super busy and have to focus on work without much time to put towards this infrastructure. At the same time, I'll day-dream and research these complex methods for meeting the same end goal -  without ever getting something up and running do to howmuch freetime I have available. Rather than let "perfect" be the enemy of "good" - we're going to identify the multiple approaches - and target the option that produces the goals without over-engineering initially. 

## High Level Plan
- DNS that routes a legit domain internally.
- A "stable" kubernetes cluster (Highly-available) to provide long-lived services. Ability to scale Agents.
- IaC to reproducible establish a multi-node Highly-available Cluster. Preferably using the same IaC as the stable cluster in a modular format.
- A single-node kubernetes cluster that uses large raid-spinning-disk storage and hosts services to backup data.

## Repository Structure
- [Support Services](./0-Support_Services/README.md)
  - Documenting the supporting services to other infrastructure and services
- [Infrastructure](./1-Infrastructure/README.md)
  - Documenting the Infrastructure for my Home Lab
- [Orchestration](./2-Orchestration/README.md)
  - Documenting orchestration (and maybe storing GitOps manifests hopefully)

## Notes and Current Thoughts

### Priority
- [Mover](https://github.com/brandtkeller/Mover) MVP
- Hugo + Nginx
- Nginx Reverse Proxy for serving multiple domains from a single public IP

### Investigation
- Investigate kube-VIP for node comms loadbalancing
  - How necessary is this really?
- create an infrastructure directory under `0-Support_Services`
  - Create a zarf.yaml manifest for the infrastructure node
    - NFS server
    - Docker registry pull-through caches
      - docker hub
      - registry1
    - S3 compatible storage
- telmate/prox-api-go
    - Build CLI for local dev?
    - Integrate with k8s autoscaler?
- Rsync Cronjob chart to redundant storage (Onsite-Backup)
- velero configuration to S3 (Offsite-Backup)
- Cert-manager to keep certificates automatically up-to-date