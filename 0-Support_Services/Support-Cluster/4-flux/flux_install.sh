#!/usr/local/bin/bash
set +o history

export REGISTRY1_USERNAME=$(cat ~/.ib_creds.yaml | grep username | awk '{ print $2 }' | tr -d '"')
export REGISTRY1_PASSWORD=$(cat ~/.ib_creds.yaml | grep password | awk '{ print $2 }' | tr -d '"')

$HOME/repos/platform-one/big-bang/bigbang/scripts/install_flux.sh -u $REGISTRY1_USERNAME -p $REGISTRY1_PASSWORD

# Turn on bash history
set -o history