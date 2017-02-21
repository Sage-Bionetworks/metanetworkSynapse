#!/bin/bash

module load openmpi-x86_64

#location of metanetwork synapse scripts (i.e. the directory this script should be in)
pathv=$( cd $(dirname $0) ; pwd -P )/

. $pathv/config.sh

# location of expression matrix
dataFile="$outputpath/Expression.csv"

#number of cores to reserve for MICor jobs
nthreadsLight=16

#number of cores to reserve for regression jobs
nthreadsMedium=128

#number of cores to reserve for computationally intensive jobs
nthreadsHeavy=256

### build nets ###

heavyNets=( "genie3" )

for net in ${heavyNets[@]}; do
	qsub -r yes -v dataFile=$dataFile,pathv=$pathv,numberCore=$nthreadsHeavy,outputpath=$outputpath -pe mpi $nthreadsHeavy -S /bin/bash -V -cwd -N "$net" -e "$errorOutput/${net}error.txt" -o "$outOutput/${net}out.txt" $pathv/networkScripts/${net}.sh
done
