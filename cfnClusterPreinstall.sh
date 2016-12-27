#!/bin/bash

sudo mkdir /home/ec2-user/src/
cd /home/ec2-user/src/


sudo yum remove -y R-core R-core-devel R-java R-java-devel
sudo yum update -y
sudo yum install -y curl curl-devel libcurl libcurl-devel readline readline-devel readline-static environment-modules


sudo wget http://sourceforge.net/projects/slurm-roll/files/addons/6.1.1/rpms/pb-binutils224-2.24-1.x86_64.rpm
sudo rpm -Uvh pb-binutils224-2.24-1.x86_64.rpm
export PATH=/opt/pb/binutils-2.24/bin:$PATH

wget http://github.com/xianyi/OpenBLAS/archive/v0.2.15.tar.gz
tar xzf v0.2.15.tar.gz
cd OpenBLAS-0.2.15/
sudo make BINARY=64 FC=gfortran USE_THREAD=1 && sudo make install && sudo make clean

# Copy openblas to lapak and blas library
sudo cp /opt/OpenBLAS/lib/libopenblas.so /opt/OpenBLAS/lib/liblapack.so.3
sudo cp /opt/OpenBLAS/lib/libopenblas.so /opt/OpenBLAS/lib/libblas.so.3
export LD_LIBRARY_PATH=/opt/OpenBLAS/lib:$LD_LIBRARY_PATH



cd /home/ec2-user/src

## Newer version of git from source
sudo yum remove -y git
sudo yum groupinstall -y "Development Tools"
sudo yum install -y gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel expat-devel
sudo yum install -y gcc perl-ExtUtils-MakeMaker

wget https://github.com/git/git/archive/master.tar.gz
tar -xzf master.tar.gz
cd git-master
sudo make configure
./configure --prefix=/usr/local --with-curl
sudo make all && sudo make install && sudo make clean


## Install R from source with dependencies
# Install R dependencies
sudo yum -y install libpng-devel libjpeg-devel libtiff-devel ghostscript-devel curl curl-devel libcurl libcurl-devel

cd /home/ec2-user/src
wget http://downloads.sourceforge.net/project/modules/Modules/modules-3.2.10/modules-3.2.10.tar.gz
tar xzf modules-3.2.10.tar.gz
cd modules-3.2.10/
sudo ./configure
sudo make && sudo make install && sudo make clean



# Install latest version of openmpi
cd /home/ec2-user/src
wget https://www.open-mpi.org/software/ompi/v2.0/downloads/openmpi-2.0.1.tar.gz
tar xzf openmpi-2.0.1.tar.gz
cd openmpi-2.0.1/
sudo ./configure
sudo make && sudo make install && sudo make clean
export LD_LIBRARY_PATH=/usr/lib64/openmpi/lib:$LD_LIBRARY_PATH

#sudo module add openmpi-2.0-x86_64

# Install zlib from source
cd /home/ec2-user/src
wget http://zlib.net/zlib-1.2.8.tar.gz
tar xzvf zlib-1.2.8.tar.gz
cd zlib-1.2.8
./configure --prefix=/usr/local/
sudo make && sudo make install && sudo make clean

export PATH=/usr/local/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/lib:/opt/OpenBLAS/lib:/usr/lib64/openmpi/lib:$LD_LIBRARY_PATH
export CFLAGS="-I/usr/local/include"
export LDFLAGS="-L/usr/local/lib"

# Install bzip from source
cd /home/ec2-user/src
wget http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz
tar xzvf bzip2-1.0.6.tar.gz
cd bzip2-1.0.6
sudo make -f Makefile-libbz2_so
sudo make install PREFIX=/usr/local
sudo make clean

# Install xz from source
cd /home/ec2-user/src
wget http://tukaani.org/xz/xz-5.2.2.tar.gz
tar xzvf xz-5.2.2.tar.gz
cd xz-5.2.2
./configure --prefix=/usr/local
sudo make -j3 && sudo make install && sudo make clean

# Install pcre from source
cd /home/ec2-user/src
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.38.tar.gz
tar xzvf pcre-8.38.tar.gz
cd pcre-8.38
./configure --prefix=/usr/local --enable-utf8
sudo make -j3 && sudo make install && sudo make clean

# Install curl from source
cd /home/ec2-user/src
wget --no-check-certificate https://curl.haxx.se/download/curl-7.47.1.tar.gz
tar xzvf curl-7.47.1.tar.gz
cd curl-7.47.1
./configure --prefix=/usr/local
sudo make -j3 && sudo make install && sudo make clean

## Get R from source
cd /home/ec2-user/src
wget https://cran.r-project.org/src/base/R-3/R-3.3.2.tar.gz
tar xzf R-3.3.2.tar.gz
cd R-3.3.2
./configure --with-cairo --with-x --with-jpeglib --with-readline --with-tclk --with-blas  --enable-R-shlib --enable-BLAS-shlib --enable-R-profiling --enable-memory-profiling JAVA_HOME=/usr/lib/jvm/java-openjdk
sudo make && sudo make install && sudo make clean

# Link openblas library for R blas
sudo mv /usr/local/lib64/R/lib/libRblas.so /usr/local/lib64/R/lib/libRblas.so.keep
sudo ln -s /opt/OpenBLAS/lib/libopenblas.so /usr/local/lib64/R/lib/libRblas.so

## Use RStudio CDN as mirror
## Set a default CRAN repo


cd /home/ec2-user
sudo echo "options(repos = list(CRAN=\"http://cran.rstudio.com/\"))" > Rprofile.site
sudo echo ".libPaths(\"/shared/rlibs\")" >> Rprofile.site
sudo cp /home/ec2-user/Rprofile.site /usr/local/lib64/R/etc/Rprofile.site

#!/bin/bash
mkdir /shared/rlibs

## Install R packages
Rscript -e 'install.packages(c("docopt", "devtools", "dplyr", "tidyr", "ggplot2", "reshape2", "knitr", "stringr", "readr", "plyr", "data.table", "rJava", "doParallel", "snow", "igraph", "Rcpp", "RcppEigen", "Rclusterpp", "RColorBrewer", "MRCE", "vbsr", "ctv", "psych", "reshape2", "vcd", "erer", "fpc", "pacman"))'

## Install synapse R client
Rscript -e 'install.packages(c("RJSONIO", "RCurl", "digest")); source("http://depot.sagebase.org/CRAN.R"); pkgInstall(c("synapseClient"))'

## Install base bioconductor packages
Rscript -e 'source("http://www.bioconductor.org/biocLite.R") ; biocLite(c("limma", "biovizBase", "e1071", "org.Hs.eg.db", "edgeR", "AnnotationDbi", "biomaRt", "ComplexHeatmap", "FDb.InfiniumMethylation.hg19", "RDAVIDWebService", "topGO", "goseq", "GO.db", "GSVA", "org.Hs.eg.db", "edgeR", "limma", "CePa", "Biobase", "pracma", "annotate", "BiocInstaller", "Biostrings", "GEOquery", "GOstats", "graph", "GSEABase", "impute", "preprocessCore"))'

## Install rGithub client
Rscript -e 'library(devtools); install_github("brian-bot/githubr")'

## Install covariate analysis package from th1vairam
Rscript -e 'library(devtools); install_github("th1vairam/CovariateAnalysis@dev")'

## Install metanetwork from blogsdon
Rscript -e 'library(devtools); install_github("blogsdon/metanetwork")'

## Install Rmpi
export LD_LIBRARY_PATH=/usr/lib64/openmpi-1.10/lib:$LD_LIBRARY_PATH
Rscript -e 'install.packages("Rmpi", configure.args = paste("--with-Rmpi-include=/usr/include/openmpi-1.10-x86_64", "--with-Rmpi-libpath=/usr/lib64/openmpi-1.10/lib", "--with-Rmpi-type=OPENMPI"))'

## Install additional R packages
Rscript -e 'install.packages(c("WGCNA", "idr"))'


sudo cp /home/centos/openblas.sh /etc/profile.d/
sudo cp /home/centos/openmpi.sh /etc/profile.d/
