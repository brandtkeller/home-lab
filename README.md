# Home Lab

> [!IMPORTANT]  
> As of 4/7/24 I am beginning to refresh the homelab infrastructure.

Update: 4/7/24
Plan:
- Update the network to be more robust. Less bottlenecks and able to support higher ISP offerings
- Focus on bare-metal for persistent machines and virtual machines for experimentation
- Establish a "Core" node that will house support services - Storage, DNS, etc
- Establish a "Prod" cluster - 3x control-plane machines and 1-2x agents (all 2.5gb networking)
- Deploy the home stack -> integrate renovate to track updates to dependencies
- Re-establish proxmox cluster for Virtual Machines

> [!WARNING]
> All Content below may be outdated or changed.

### What is a Home Lab?
Machines and software that you run at home in order to learn new technologies and Host services that you and others within your LAN (Local Area Network) can use and rely upon without incurring the cost of cloud services.

### Where do you source equipment?
Check your local classifieds/ebay/etc. Beefy machines of 1-2 generations old can often be found for sale from entities that upgrade often. 

### What are your primary goals/objectives?
- First and foremost, established required services in a sustainable and reproducible fashion
- Second, Identify both "good" and "ideal" solutions - If "ideal" will consume 2x more time - execute with "good" first

### Why not shoot for "ideal"?
I focus on my daily work responsibilities without having to interact with this equipment often (Maybe I should change that in order to justify testing these services more). More often than not, I'll get super busy and have to focus on work without much time to put towards this infrastructure. At the same time, I'll day-dream and research these complex methods for meeting the same end goal -  without ever getting something up and running due to how much free-time I have available. Rather than let "perfect" be the enemy of "good" - we're going to identify the multiple approaches - and target the option that produces the goals without over-engineering initially. 

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

### Goals
- Highly Available Kubernetes Cluster w/ 3x Server nodes and minimum of 2x agent nodes (TBD).
  - Server nodes hosts Kube-VIP and manage traffic routing
- 1x agent node inside the house for Zwave
- 1 -> N agent node(s) in the office for Zwave & NFS
  - Continue to use NUC due to footprint and resource requirements
    - Stays online in the event of power failure

### Questions
- Do we need a storage class on any of the server nodes?
  - Move zwave home to agent node then no
- Can we reformat the cluster entirely? 
  - Would we lose any data?
  - Would we lose any configuration?
- How could we migrate the database VM to the NUC?
  - How is migration done generically?
- 
### Execution

#### Bootstrap
- Create new support-services cluster
  - How do I make this easily transferrable across compute?
    - This is further complicated by the large storage only being accessible by a single VM
    - Could attempt an in-place upgrade but that could be risky
    - Velero w/ NFS backend 
  - Build to be scalable if required
  - Deploy infrastructure
    - Cert-manager
    - kube-vip
  - Deploy databases
    - Cloudnative PG
  - Migrate databases as required
    - Nextcloud
  - Deploy NFS server
- Backup data as required
- Clear all compute
  - Uninstall from bare-metal
  - Destroy VMs
- Create first server node
- Join server 2 & 3
- Join Agents
  - Laptop Agent in House?
  - 2x Prox VM's 
- Deploy zarf-init-longhorn package
  - Add NFS backup endpoint
- Deploy NFS provisioner package
- Deploy Infrastructure package
- Deploy DNS
  - Run on server nodes only?
  - LoadBalancer Service
- Restore PVC's
- Deploy Nextcloud
- Deploy Home Assistant


