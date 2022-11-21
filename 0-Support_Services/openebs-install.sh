#!/bin/bash

helm install localpv openebs-localpv/localpv-provisioner -n openebs -f openebs/localpv-values.yaml --create-namespace

helm install jiva openebs-jiva/jiva -n openebs -f openebs/jiva-values.yaml