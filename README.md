#metanetworkSynapse
###Simulating Data
To run the test scripts, first simulate some data, e.g. using the [metanetwork](https://github.com/blogsdon/metanetwork/tree/metanetworkReboot) r-package.

`foo = metanetwork::simulateNetworkData(100,100,2/100,adjustment=0.5)`

write this data to a file.

`write.csv(foo$data,file='~/testData.csv',quote=F)`

###Building Correlation/Mutual Information networks
The test script is organized as follow.  First spin up either the starcluster or cfncluster queue.  Next clone the current versions of the [metanetwork](https://github.com/blogsdon/metanetwork/tree/metanetworkReboot) and [metanetworkSynapse](https://github.com/blogsdon/metanetworkSynapse/tree/metanetworkSynapseReboot) repos onto the shared EBS volume for your cluster.  To submit a job to fit the correlation/mutual information method, you can run modify the [testNetworkMICorSubmission.sh](https://github.com/blogsdon/metanetworkSynapse/blob/metanetworkSynapseReboot/testNetworkMICorSubmission.sh) as follows.

First, set the number of threads to reserve for the job

`nthreads=1`

Next, define the path of the s3 buckets where the outputs will go

`s3="s3://metanetworks/testNetwork/"`

Third, set the path of the file that contains the simulated data

`dataFile="/shared/testNetwork/testData.csv"`

Define the path of the metanetwork repo

`pathv="/shared/metanetworkSynapse/"`

Define the path of where you want the temporary output of the networks to go

`outputpath="/shared/testNetwork/"`

Define the path in the metanetworks buckets

`s3b="testNetwork"`

Define the parentId of the folder in the metanetworks Synapse project where you want the network outputs to go

`parentId="syn5706584"`

Define the path to the file that contains the annotations you want to put on these files.  Here is an [example](https://github.com/blogsdon/CRANIO/blob/master/annoFile.txt)

`annotationFile="/shared/testNetwork/annoFile.txt"`

Define the path to the file that contains the provenance you want to put on these files.  Here is an [example](https://github.com/blogsdon/CRANIO/blob/master/provenanceFile.txt)

`provenanceFile="/shared/testNetwork/provenanceFile.txt"`

Define a path to where you want the STDERR to go

`errorOutput="/shared/testNetwork/marginalerror.txt"`

Define a path to where you want the STDOUT to go

`outOutput="/shared/testNetwork/marginalout.txt"`

Define a job name

`jobname="testNetworkMarginal"`

Submit the job

`qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,c3net=1,mrnet=1,wgcnaTOM=1,sparrowZ=0,lassoCV1se=0,ridgeCV1se=0,genie3=0,tigress=0,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe orte $nthreads -S /bin/bash -V -cwd -N $jobname -e $errorOutput -o $outOutput $pathv/buildNet.sh`

#Building Regression networks

You can run modify the [testNetworkRegressionSubmission.sh](https://github.com/blogsdon/metanetworkSynapse/blob/metanetworkSynapseReboot/testNetworkRegressionSubmission.sh) as above.  Importantly, the regression methods are all embarrasingly parallelized. To take advantage of this set the number of threads to reserve for the job to the number of cores in the cluster.  E.g. if you spun up a cluster with 320 cores

`nthreads=319`

finally, when you submit the job set the regression flags to 1

`qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,c3net=0,mrnet=0,wgcnaTOM=0,sparrowZ=1,lassoCV1se=1,ridgeCV1se=1,genie3=1,tigress=1,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe orte $nthreads -S /bin/bash -V -cwd -N $jobname -e $errorOutput -o $outOutput $pathv/buildNet.sh`