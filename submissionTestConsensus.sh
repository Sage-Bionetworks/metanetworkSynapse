#!/bin/sh

#location of metanetwork synapse scripts (i.e. the directory this script should be in)
pathv=$( cd $(dirname $0) ; pwd -P )/

. $pathv/configTest.sh

# number of cores to reserve (building the rank consensus network runs serially, but requires a lot of memory)
nthreads=2

qsub -r yes -v dataFile=$dataFile,pathv=$pathv,outputpath=$outputpath,networkFolderId=$parentId -pe mpi $nthreads -S /bin/bash -V -cwd -N "rankConsensus" -e $errorOutput/rankConsensuserror.txt -o $outOutput/rankConsensusout.txt $pathv/networkScripts/rankConsensus.sh
