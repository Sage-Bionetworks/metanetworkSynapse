#!/bin/bash

#re-install openmpi from source
wget https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-1.10.0.tar.gz
sudo gunzip -c openmpi-1.10.0.tar.gz | tar xf -
cd openmpi-1.10.0
sudo ./configure --prefix=/usr/local --with-sge
sudo make all install
cd ~/

#install R
wget https://cran.r-project.org/src/base/R-3/R-3.2.2.tar.gz
tar -xzvf R-3.2.2.tar.gz
cd R-3.2.2
sudo ./configure --with-x=no
sudo make
sudo make install
cd ~/

# to /usr/local/lib64/R/etc/ldpaths
# add this line LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
# after line 16
sudo sed -i '17 i\
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
' /usr/local/lib64/R/etc/ldpaths


#install all necessary R packages

echo 'install.packages(c("vbsr", "dplyr", "Rmpi", "data.table", "glmnet", "randomForest", "lars"),contriburl=contrib.url("http://cran.fhcrc.org/"))' > installScript.R

su -c 'Rscript installScript.R'

echo 'source("http://bioconductor.org/biocLite.R")' > installScript.R
echo 'biocLite(c("impute","preprocessCore","GO.db","AnnotationDbi"))' >> installScript.R


su -c 'Rscript installScript.R'


echo 'install.packages(c("WGCNA","Hmisc"),contriburl=contrib.url("http://cran.fhcrc.org/"))' > installScript.R

su -c 'Rscript installScript.R'

echo 'source("http://depot.sagebase.org/CRAN.R")
pkgInstall("synapseClient")' > installScript.R

su -c 'Rscript installScript.R' 


echo 'install.packages(c("devtools"),contriburl=contrib.url("http://cran.fhcrc.org/"))' > installScript.R

su -c 'Rscript installScript.R'

echo 'require(devtools);install_github("blogsdon/metanetwork");' > installScript.R

su -c 'Rscript installScript.R'
# #install metanetwork
# git clone https://github.com/blogsdon/metanetwork.git
# su -c 'R CMD INSTALL metanetwork'
# #install metanetworkSynapse
# git clone https://github.com/blogsdon/metanetworkSynapse.git
# 
# #install ROSMAP
# git clone https://github.com/blogsdon/ROSMAP.git
# 
# #install CMC
  # git clone https://github.com/blogsdon/CMC.git


sudo /usr/local/sbin/ami_cleanup.sh
