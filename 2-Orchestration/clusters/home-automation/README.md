# Home Automation Cluster

Cluster used to provide home automation orchestration. This resides on a subnet separate from my other clusters that I will use for automation purposes.

## Plans
- Zarf init w/ k3s component on a fresh ubuntu 22.04 install - done
- Investigate or create a helm chart for home assistant + zwave2mqtt
- Orchestrate a zarf package for both component and cluster
    - Create variable for zwave usb device declaration

## Deployment Process

- Individual Flux package
    - Allows for the orchestration of flux separate from the rest of the orchestration
    - Need an action that is optional for the addition of the sops secret
- Automation Orchestration package
    - All other components of the system


## Ideal Architecture

- k3s
- zarf init
- zarf package
    - flux
    - istio
        - controlplane
            - gateway w/ cert
        - operator
    - home-assistant + zwavejs
    - home-assistant virtualservice
