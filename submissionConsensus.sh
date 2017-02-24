#!/bin/sh

#location of metanetwork synapse scripts (i.e. the directory this script should be in)
pathv=$( cd $(dirname $0) ; pwd -P )/

. $pathv/config.sh

# number of cores to reserve (building the rank consensus network runs serially, but requires a lot of memory)
nthreads=4

qsub -r yes -v dataFile="$outputpath/Expression.csv",pathv=$pathv,outputpath=$outputpath,networkFolderId=$parentId -pe mpi $nthreads -S /bin/bash -V -cwd -N "rankConsensus" -e $errorOutput/rankConsensuserror.txt -o $outOutput/rankConsensusout.txt $pathv/networkScripts/rankConsensus.sh
