# Home Automation Cluster

Cluster used to provide home automation orchestration. This resides on a subnet separate from my other clusters that I will use for automation purposes.

## Plans
- Zarf init w/ k3s component on a fresh ubuntu 22.04 install - done
- Investigate or create a helm chart for home assistant + zwave2mqtt
- Orchestrate a zarf package for both component and cluster
    - Create variable for zwave usb device declaration
