# Support Services

This will outline the plan and catalog the current state of support services.

## Services
- On-premise Loadbalancer
- On-premise DNS

## Plan
- Creation of DNS and loadbalancer daemonset orchestration.

## Questions
- How to template DNS to make each pod aware of nodeIP 
    - What does this look like for the pod? Does coredns have utilities to find/replace? (sed?)
    - If so, put a unique identifier in the configmap and replace it at startup
    - if not..... back to whiteboard