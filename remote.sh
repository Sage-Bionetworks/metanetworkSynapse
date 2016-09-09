#!/bin/bash

# general setup
synId=$1
sudo yum update -y
mkdir /shared/rlibs
git clone https://github.com/philerooski/metanetworkSynapse.git /shared/metanetworkSynapse
sudo chown centos /shared/rlibs
module load openmpi-x86_64
Rscript -e 'install.packages("Rmpi", configure.args = paste("--with-Rmpi-include=/usr/include/openmpi-x86_64","--with-Rmpi-libpath=/usr/lib64/openmpi/lib","--with-Rmpi-type=OPENMPI"))'
sh ~/rpackages_provisioner.sh
Rscript -e 'install.packages(c("bit64", "parmigene", "c3net", "ROCR", "Matrix", "glasso"))'

# test network
mkdir /shared/testNetwork && mkdir /shared/testNetwork/errorLogs && mkdir /shared/testNetwork/outLogs
Rscript -e "library(metanetwork); foo = metanetwork::simulateNetworkData(100,100,2/100,adjustment=0.5); write.csv(foo$data,file='/shared/testNetwork/testData.csv',quote=F)"
echo -e "provenance,executed\nhttps://github.com/philerooski/sage.gtex/blob/master/brain_expressions.py,TRUE" > /shared/testNetwork/provenanceFile.txt
echo "hello,goodbye" > /shared/testNetwork/annoFile.txt

# actual network
mkdir /shared/network && mkdir /shared/network/errorLogs && mkdir /shared/network/outLogs
Rscript -e "library(synapseClient); synapseLogin(); synGet($synId, downloadLocation='/shared/network/')"
