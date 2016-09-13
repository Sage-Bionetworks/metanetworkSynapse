#!/bin/bash
key=$1
address=$2
synId=$3

# move over essentials
scp -i $key ./remote.sh ~/.synapseConfig centos@$address:~/
ssh -i $key centos@$address 'mkdir /shared/.aws'
scp -i $key ~/.aws/credentials centos@$address:/shared/.aws/

# run setup script on remote
ssh -i $key centos@$address 'sh ~/remote.sh ${synId}'
