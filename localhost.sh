#!/bin/bash
# must be run within metanetworkSynapse
key=$1
address=$2
branch=$( git rev-parse --abbrev-ref HEAD )

# move over essentials
scp -i $key ~/.synapseConfig centos@$address:~/
ssh -i $key centos@$address "git clone -b $branch https://github.com/philerooski/metanetworkSynapse.git /shared/metanetworkSynapse/"

# run setup script on remote
ssh -n -f -i $key centos@$address "sh -c 'nohup sh /shared/metanetworkSynapse/remote.sh > /dev/null 2>&1 &'"
