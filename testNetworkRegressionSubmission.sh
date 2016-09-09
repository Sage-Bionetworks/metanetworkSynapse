#!/bin/bash

module load openmpi-x86_64

#location of metanetwork synapse scripts
pathv="/shared/metanetworkSynapse/"

. $pathv/config.sh

#number of cores to reserve for job
nthreads=4

#path to csv file with annotations to add to file on Synapse
annotationFile="$outputpath/annoFile.txt"

#path to csv file with provenance to add to file on synapse
provenanceFile="$outputpath/provenanceFile.txt"

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N "sparrowZ" -e "$errorOutput/sparrowZerror.txt" -o "$outOutput/sparrowZout.txt" $pathv/networkScripts/sparrowZ.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N "sparrow2Z" -e "$errorOutput/sparrow2Zerror.txt" -o "$outOutput/sparrow2Zout.txt" $pathv/networkScripts/sparrow2Z.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N "lassoAIC" -e "$errorOutput/lassoAICerror.txt" -o "$outOutput/lassoAICout.txt" $pathv/networkScripts/lassoAIC.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N  "lassoBIC" -e "$errorOutput/lassoBICerror.txt" -o "$outOutput/lassoBICout.txt" $pathv/networkScripts/lassoBIC.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N  "lassoCV1se" -e "$errorOutput/lassoCV1seerror.txt" -o "$outOutput/lassoCV1seout.txt" $pathv/networkScripts/lassoCV1se.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N  "ridgeAIC" -e "$errorOutput/ridgeAICerror.txt" -o "$outOutput/ridgeAICout.txt" $pathv/networkScripts/ridgeAIC.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N  "ridgeBIC" -e "$errorOutput/ridgeBICerror.txt" -o "$outOutput/ridgeBICout.txt" $pathv/networkScripts/ridgeBIC.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N  "ridgeCV1se" -e "$errorOutput/ridgeCV1seerror.txt" -o "$outOutput/ridgeCV1seout.txt" $pathv/networkScripts/ridgeCV1se.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N  "ridgeCVmin" -e "$errorOutput/ridgeCVminerror.txt" -o "$outOutput/ridgeCVminout.txt" $pathv/networkScripts/ridgeCVmin.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N  "genie3" -e "$errorOutput/genie3error.txt" -o "$outOutput/genie3out.txt" $pathv/networkScripts/genie3.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N  "tigress" -e "$errorOutput/tigresserror.txt" -o "$outOutput/tigressout.txt" $pathv/networkScripts/tigress.sh

#s3=$s3 dataFile=$dataFile pathv=$pathv c3net=0 mrnet=0 wgcnaTOM=0 sparrowZ=1 lassoCV1se=1 ridgeCV1se=1 genie3=1 tigress=1 numberCore=$nthreads outputpath=$outputpath s3b=$s3b parentId=$parentId annotationFile=$annotationFile provenanceFile=$provenanceFile bucket=$bucket $pathv/pushNetS3.sh
