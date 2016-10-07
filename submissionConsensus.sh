#!/bin/sh

#location of metanetwork synapse scripts (i.e. the directory this script should be in)
pathv=$( cd $(dirname $0) ; pwd -P )/

. $pathv/config.sh

qsub -r yes -v dataFile=$dataFile,pathv=$pathv,outputpath=$outputpath,networkFolderId=$parentId -pe mpi $nthreads -S /bin/bash -V -cwd -N "rankConsensus" -e $errorOutput/rankConsensuserror.txt -o $outOutput/rankConsensusout.txt $pathv/networkScripts/rankConsensus.sh
