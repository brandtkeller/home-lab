# changelog
I'll be using this less as an actual changelog and more to document updates. As I have described elsewhere - homelab is a best effort with other competing priorities. 



Update: 4/26/24
Network upgraded to support 2.5Gbe as the bottleneck until the modem (currently still gigabit). 
10Gbe connection between Office and House

Update: 4/7/24
Plan:
- Update the network to be more robust. Less bottlenecks and able to support higher ISP offerings
- Focus on bare-metal for persistent machines and virtual machines for experimentation
- Establish a "Core" node that will house support services - Storage, DNS, etc
- Establish a "Prod" cluster - 3x control-plane machines and 1-2x agents (all 2.5gb networking)
- Deploy the home stack -> integrate renovate to track updates to dependencies
- Re-establish proxmox cluster for Virtual Machines