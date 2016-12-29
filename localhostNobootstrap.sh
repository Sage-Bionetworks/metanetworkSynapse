#!/bin/bash
key=$1
address=$2
repo=$3
cwd=$( cd $(dirname $0) ; pwd -P )/

# move over essentials
if [ -e ~/.synapseConfig ]; then
    scp -i $key ~/.synapseConfig centos@$address:~/
else
    echo "~/.synapseConfig not found, skipping file transfer."
fi
ssh -i $key centos@$address "git clone $3 /shared/metanetworkSynapse/"
scp -i $key $cwd/config.sh centos@$address:/shared/metanetworkSynapse/

# run setup script on remote
ssh -n -f -i $key centos@$address "sh -c 'nohup sh /shared/metanetworkSynapse/remoteNobootstrap.sh > /dev/null 2>&1 &'"
