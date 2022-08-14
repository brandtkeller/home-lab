# Home Infrastructure
A catalog of the current and planned state for my Home Lab.

I wanted to document and catalog the updates to my home lab for multiple reasons:
- Assist in capturing plans for modifications to the hardware and identify dependencies. 
- Provide a space for documenting what is deployed and how.
- Ensure all configurations are either declarative or idempotent - such that this can evolve over time.

## Work In-progress
- Deployment of "stable" RKE2 cluster
  - TODO:
    - Certificate Information - `kellerhome.us`
      - `k8s.kellerhome.us`
      - `*.k8s.kellerhome.us`
    - DNS entries
      - Short-term:
        - Update existing DNS server
      - Long-term:
        - Create Highly-available and declarative DNS 
    - Loadbalancer
      - Short-term:
        - Create Loadbalancer on dev machine
      - Long-term:
        - Create Highly-available and decalartive loadbalancing service


