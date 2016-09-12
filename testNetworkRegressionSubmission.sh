#!/bin/bash

module load openmpi-x86_64

#location of metanetwork synapse scripts
pathv="/shared/metanetworkSynapse/"

. $pathv/config.sh

#number of cores to reserve for job
nthreads=8

#number of cores to reserve for pushing networks to S3/Synapse
nthreadsPush=1

#path to csv file with annotations to add to file on Synapse
annotationFile="$outputpath/annoFile.txt"

#path to csv file with provenance to add to file on synapse
provenanceFile="$outputpath/provenanceFile.txt"

### build nets ###

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

### push nets ###

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,bucket=$bucket -pe mpi $nthreadsPush -S /bin/bash -V -cwd -hold_jid "sparrowZ" -N "push-sparrowZ" -e "$errorOutput/push/sparrowZerror.txt" -o "$outOutput/push/sparrowZout.txt" $pathv/pushScripts/sparrowZ.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,bucket=$bucket -pe mpi $nthreadsPush -S /bin/bash -V -cwd -hold_jid "sparrow2Z" -N "push-sparrow2Z" -e "$errorOutput/push/sparrow2Zerror.txt" -o "$outOutput/push/sparrow2Zout.txt" $pathv/pushScripts/sparrow2Z.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,bucket=$bucket -pe mpi $nthreadsPush -S /bin/bash -V -cwd -hold_jid "lassoAIC" -N "push-lassoAIC" -e "$errorOutput/push/lassoAICerror.txt" -o "$outOutput/push/lassoAICout.txt" $pathv/pushScripts/lassoAIC.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,bucket=$bucket -pe mpi $nthreadsPush -S /bin/bash -V -cwd -hold_jid "lassoBIC" -N "push-lassoBIC" -e "$errorOutput/push/lassoBIC.txt" -o "$outOutput/push/lassoBIC.txt" $pathv/pushScripts/lassoBIC.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,bucket=$bucket -pe mpi $nthreadsPush -S /bin/bash -V -cwd -hold_jid "lassoCV1se" -N "push-lassoCV1se" -e "$errorOutput/push/lassoCV1seerror.txt" -o "$outOutput/push/lassoCV1seout.txt" $pathv/pushScripts/lassoCV1se.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,bucket=$bucket -pe mpi $nthreadsPush -S /bin/bash -V -cwd -hold_jid "ridgeAIC" -N "push-ridgeAIC" -e "$errorOutput/push/ridgeAICerror.txt" -o "$outOutput/push/ridgeAICout.txt" $pathv/pushScripts/ridgeAIC.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,bucket=$bucket -pe mpi $nthreadsPush -S /bin/bash -V -cwd -hold_jid "ridgeBIC" -N "push-ridgeBIC" -e "$errorOutput/push/ridgeBICerror.txt" -o "$outOutput/push/ridgeBICout.txt" $pathv/pushScripts/ridgeBIC.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,bucket=$bucket -pe mpi $nthreadsPush -S /bin/bash -V -cwd -hold_jid "ridgeCV1se" -N "push-ridgeCV1se" -e "$errorOutput/push/ridgeCV1seerror.txt" -o "$outOutput/push/ridgeCV1seout.txt" $pathv/pushScripts/ridgeCV1se.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,bucket=$bucket -pe mpi $nthreadsPush -S /bin/bash -V -cwd -hold_jid "ridgeCVmin" -N "push-ridgeCVmin" -e "$errorOutput/push/ridgeCVminerror.txt" -o "$outOutput/push/ridgeCVminout.txt" $pathv/pushScripts/ridgeCVmin.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,bucket=$bucket -pe mpi $nthreadsPush -S /bin/bash -V -cwd -hold_jid "genie3" -N "push-genie3" -e "$errorOutput/push/genie3error.txt" -o "$outOutput/push/genie3out.txt" $pathv/pushScripts/genie3.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,bucket=$bucket -pe mpi $nthreadsPush -S /bin/bash -V -cwd -hold_jid "tigress" -N "push-tigress" -e "$errorOutput/push/tigresserror.txt" -o "$outOutput/push/tigressout.txt" $pathv/pushScripts/tigress.sh
