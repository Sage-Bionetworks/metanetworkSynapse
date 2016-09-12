#!/bin/bash

# general setup
synId=$1
sudo yum update -y
echo "export PS1=\"\n\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;38m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\h[\[$(tput sgr0)\]\[\033[38;5;214m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\]]: \[$(tput sgr0)\]\"" >> ~/.bashrc
echo "export AWS_CONFIG_FILE=\"/shared/.aws/credentials\"" >> ~/.bashrc
mkdir /shared/rlibs
sudo chown centos /shared/rlibs
module load openmpi-x86_64
Rscript -e 'install.packages("Rmpi", configure.args = paste("--with-Rmpi-include=/usr/include/openmpi-x86_64","--with-Rmpi-libpath=/usr/lib64/openmpi/lib","--with-Rmpi-type=OPENMPI"))'
sh ~/rpackages_provisioner.sh
Rscript -e 'install.packages(c("bit64", "parmigene", "c3net", "ROCR", "Matrix", "glasso", "utility"))'
git clone https://github.com/philerooski/metanetworkSynapse.git /shared/metanetworkSynapse

# test network
mkdir /shared/testNetwork && mkdir /shared/testNetwork/errorLogs && mkdir /shared/testNetwork/outLogs && mkdir /shared/testNetwork/outLogs/push && mkdir /shared/testNetwork/errorLogs/push
Rscript -e "library(metanetwork); foo = metanetwork::simulateNetworkData(100,100,2/100,adjustment=0.5); write.csv(foo$data,file='/shared/testNetwork/testData.csv',quote=F)"
echo -e "provenance,executed\nhttps://github.com/philerooski/sage.gtex/blob/master/brain_expressions.py,TRUE" > /shared/testNetwork/provenanceFile.txt
echo "hello,goodbye" > /shared/testNetwork/annoFile.txt

# actual network
mkdir /shared/network && mkdir /shared/network/errorLogs && mkdir /shared/network/outLogs && mkdir /shared/network/errorLogs/push && mkdir /shared/network/outLogs/push
Rscript -e "library(synapseClient); synapseLogin(); synGet($synId, downloadLocation='/shared/network/')"
