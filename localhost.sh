#!/bin/bash
key=$1
address=$2
synId=$3

# move over essentials
scp -i $key ./remote.sh ~/.synapseConfig centos@$address:~/
ssh -i $key centos@$address 'mkdir /shared/.aws'
scp -i $key ~/.aws/credentials centos@$address:/shared/.aws/

# run setup script on remote and add PS1 and AWS_CONFIG_FILE environment vars to .bashrc
ssh -i $key centos@$address 'sh ~/remote.sh ${synId}; echo "export PS1=\"\n\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;38m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\h[\[$(tput sgr0)\]\[\033[38;5;214m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\]]: \[$(tput sgr0)\]\"" >> ~/.bashrc; echo "export AWS_CONFIG_FILE=\"/shared/.aws/credentials\"" >> ~/.bashrc'
