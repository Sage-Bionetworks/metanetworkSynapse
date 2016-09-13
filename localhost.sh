#!/bin/bash
key=$1
address=$2
synId=$3

# move over essentials
scp -i $key ./remote.sh ~/.synapseConfig centos@$address:~/
ssh -i $key centos@$address 'mkdir /shared/.aws'
scp -i $key ~/.aws/credentials centos@$address:/shared/.aws/

# run setup script on remote and add PS1 and AWS_CONFIG_FILE environment vars to .bashrc
ssh -i $key centos@$address
ssh -n -f -i $key centos@$address "sh -c 'nohup sh ~/remote.sh ${synId} > /dev/null 2>&1 &'"

