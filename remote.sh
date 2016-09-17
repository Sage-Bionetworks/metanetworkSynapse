#!/bin/bash

# general setup
synId=$1
sudo yum update -y
echo "export PS1=\"\n\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;38m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\h[\[$(tput sgr0)\]\[\033[38;5;214m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\]]: \[$(tput sgr0)\]\"" >> ~/.bashrc
echo "export AWS_CONFIG_FILE=\"/shared/.aws/credentials\"" >> ~/.bashrc
source ~/.bashrc
mkdir /shared/rlibs
sudo chown centos /shared/rlibs
module load openmpi-x86_64
Rscript -e 'install.packages("Rmpi", configure.args = paste("--with-Rmpi-include=/usr/include/openmpi-x86_64","--with-Rmpi-libpath=/usr/lib64/openmpi/lib","--with-Rmpi-type=OPENMPI"))'
sh ~/rpackages_provisioner.sh
Rscript -e 'install.packages(c("bit64", "parmigene", "c3net", "ROCR", "Matrix", "glasso", "utility"))'

# python2.7 and dependencies install
sudo yum -y groupinstall 'Development Tools'
sudo yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel
cd /tmp
curl -0 https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz
tar xfz Python-2.7.10.tgz
cd Python-2.7.10.tgz
./configure --with-threads --enable-shared
make
sudo make altinstall
sudo ln -s /usr/local/bin/python2.7 /usr/bin/python2.7
echo "/usr/local/lib/python2.7" | sudo tee --append /etc/ld.so.conf.d/python27.conf
echo "/usr/local/lib" | sudo tee --append /etc/ld.so.conf.d/python27.conf
sudo ldconfig
python2.7 -m pip install --upgrade synapseclient
python2.7 -m pip install --upgrade argparse
cd /shared/

# test network
mkdir /shared/testNetwork && mkdir /shared/testNetwork/errorLogs && mkdir /shared/testNetwork/outLogs && mkdir /shared/testNetwork/outLogs/push && mkdir /shared/testNetwork/errorLogs/push
Rscript -e "library(metanetwork); foo = metanetwork::simulateNetworkData(100,100,2/100,adjustment=0.5); write.csv(foo$data,file='/shared/testNetwork/testData.csv',quote=F)"
echo -e "provenance,executed\nhttps://github.com/philerooski/sage.gtex/blob/master/brain_expressions.py,TRUE" > /shared/testNetwork/provenanceFile.txt
echo "hello,goodbye" > /shared/testNetwork/annoFile.txt

# actual network
mkdir /shared/network && mkdir /shared/network/errorLogs && mkdir /shared/network/outLogs && mkdir /shared/network/errorLogs/push && mkdir /shared/network/outLogs/push
Rscript -e "library(synapseClient); synapseLogin(); synGet('$synId', downloadLocation='/shared/network/')"
sh /shared/metanetworkSynapse/testNetworkMICorSubmission.sh
sh /shared/metanetworkSynapse/testNetworkRegressionSubmission.sh
