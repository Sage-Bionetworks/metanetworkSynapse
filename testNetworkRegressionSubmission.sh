#!/bin/bash

. ./config.sh

module load openmpi-x86_64

#number of cores to reserve for job
nthreads=8

#path to csv file with annotations to add to file on Synapse
annotationFile="$outputpath/annoFile.txt"

#path to csv file with provenance to add to file on synapse
provenanceFile="$outputpath/provenanceFile.txt"

#job script name
jobname="networkRegression"

# where to put error files
errorOutput="$outputpath/errorLogs"

# where to put output files
outOutput="$outputpath/outLogs"

#prefixes
sparrowZ="sparrow"
lassoCV1se="lasso"
ridgeCV1se="ridge"
genie3="genie"
tigress="tigress"

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N $sparrowZ -e "$errorOutput/${sparrowZ}error.txt" -o "$outOutput/${sparrowZ}out.txt" $pathv/networkScripts/sparrow.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N $lassoCV1se -e "$errorOutput/${lassoCV1se}error.txt" -o "$outOutput/${lassoCV1se}out.txt" $pathv/networkScripts/lasso.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N $ridgeCV1se -e "$errorOutput/${ridgeCV1se}error.txt" -o "$outOutput/${ridgeCV1se}out.txt" $pathv/networkScripts/ridge.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N $genie3 -e "$errorOutput/${genie3}error.txt" -o "$outOutput/${genie3}out.txt" $pathv/networkScripts/genie3.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N $tigress -e "$errorOutput/${tigress}error.txt" -o "$outOutput/${tigress}out.txt" $pathv/networkScripts/tigress.sh

#s3=$s3 dataFile=$dataFile pathv=$pathv c3net=0 mrnet=0 wgcnaTOM=0 sparrowZ=1 lassoCV1se=1 ridgeCV1se=1 genie3=1 tigress=1 numberCore=$nthreads outputpath=$outputpath s3b=$s3b parentId=$parentId annotationFile=$annotationFile provenanceFile=$provenanceFile bucket=$bucket $pathv/pushNetS3.sh
