#!/bin/bash

helm install jiva openebs-jiva/jiva -n openebs -f values.yaml --create-namespace