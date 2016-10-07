#!/bin/bash

module load openmpi-x86_64

#location of metanetwork synapse scripts (i.e. the directory this script should be in)
pathv=$( cd $(dirname $0) ; pwd -P )/

. $pathv/config.sh

#number of cores to reserve for MICor jobs
nthreadsLight=80

#number of cores to reserve for regression jobs
nthreadsMedium=120

#number of cores to reserve for computationally intensive jobs
nthreadsHeavy=240

### build nets ###

lightNets=( "c3net" "mrnet" "wgcnaTOM" )

mediumNets=( "lassoAIC" "lassoBIC" "lassoCV1se" "lassoCVmin" "ridgeAIC" "ridgeBIC" "ridgeCV1se" "ridgeCVmin" "sparrowZ" "sparrow2Z" )

heavyNets=( "genie3" "tigress" )

for net in ${lightNets[@]}; do
	qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreadsLight,outputpath=$outputpath -pe mpi $nthreadsLight -S /bin/bash -V -cwd -N "$net" -e "$errorOutput/${net}error.txt" -o "$outOutput/${net}out.txt" $pathv/networkScripts/${net}.sh
done

for net in ${mediumNets[@]}; do
	qsub -r yes -v dataFile=$dataFile,pathv=$pathv,numberCore=$nthreadsMedium,outputpath=$outputpath -pe mpi $nthreadsMedium -S /bin/bash -V -cwd -N "$net" -e "$errorOutput/${net}error.txt" -o "$outOutput/${net}out.txt" $pathv/networkScripts/${net}.sh
done

for net in ${heavyNets[@]}; do
	qsub -r yes -v dataFile=$dataFile,pathv=$pathv,numberCore=$nthreadsHeavy,outputpath=$outputpath -pe mpi $nthreadsHeavy -S /bin/bash -V -cwd -N "$net" -e "$errorOutput/${net}error.txt" -o "$outOutput/${net}out.txt" $pathv/networkScripts/${net}.sh
done
