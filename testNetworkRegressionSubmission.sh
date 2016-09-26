#!/bin/bash

module load openmpi-x86_64

#location of metanetwork synapse scripts
pathv="/shared/metanetworkSynapse/"

. $pathv/config.sh

#number of cores to reserve for job
nthreads=32

#number of cores to reserve for computationally intensive jobs
nthreadsHeavy=96

#path to csv file with annotations to add to file on Synapse
annotationFile="$outputpath/annoFile.txt"

#path to csv file with provenance to add to file on synapse
provenanceFile="$outputpath/provenanceFile.txt"

### build nets ###

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N "sparrowZ" -e "$errorOutput/sparrowZerror.txt" -o "$outOutput/sparrowZout.txt" $pathv/networkScripts/sparrowZ.sh

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N "sparrow2Z" -e "$errorOutput/sparrow2Zerror.txt" -o "$outOutput/sparrow2Zout.txt" $pathv/networkScripts/sparrow2Z.sh

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N "lassoAIC" -e "$errorOutput/lassoAICerror.txt" -o "$outOutput/lassoAICout.txt" $pathv/networkScripts/lassoAIC.sh

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N  "lassoBIC" -e "$errorOutput/lassoBICerror.txt" -o "$outOutput/lassoBICout.txt" $pathv/networkScripts/lassoBIC.sh

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N  "lassoCV1se" -e "$errorOutput/lassoCV1seerror.txt" -o "$outOutput/lassoCV1seout.txt" $pathv/networkScripts/lassoCV1se.sh

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N  "lassoCVmin" -e "$errorOutput/lassoCVminerror.txt" -o "$outOutput/lassoCVminout.txt" $pathv/networkScripts/lassoCVmin.sh

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N  "ridgeAIC" -e "$errorOutput/ridgeAICerror.txt" -o "$outOutput/ridgeAICout.txt" $pathv/networkScripts/ridgeAIC.sh

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N  "ridgeBIC" -e "$errorOutput/ridgeBICerror.txt" -o "$outOutput/ridgeBICout.txt" $pathv/networkScripts/ridgeBIC.sh

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N  "ridgeCV1se" -e "$errorOutput/ridgeCV1seerror.txt" -o "$outOutput/ridgeCV1seout.txt" $pathv/networkScripts/ridgeCV1se.sh

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N  "ridgeCVmin" -e "$errorOutput/ridgeCVminerror.txt" -o "$outOutput/ridgeCVminout.txt" $pathv/networkScripts/ridgeCVmin.sh

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreadsHeavy,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreadsHeavy -S /bin/bash -V -cwd -N  "genie3" -e "$errorOutput/genie3error.txt" -o "$outOutput/genie3out.txt" $pathv/networkScripts/genie3.sh

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreadsHeavy,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreadsHeavy -S /bin/bash -V -cwd -N  "tigress" -e "$errorOutput/tigresserror.txt" -o "$outOutput/tigressout.txt" $pathv/networkScripts/tigress.sh
