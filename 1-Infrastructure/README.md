# Infrastructure

This document will outline the plan and catalog current state of the infrastructure.

## Scope
- Installation of only REQUIRED tooling via package managers.
- Anything that can be packaged and installed with zarf should do so. Distro specific packages w/ complex dependencies can be baked into the base image.

## Plan

- Disk Health analysis - Review current raid arrays
- Install New SSD
- Raid 1 initialize 2x SSD's