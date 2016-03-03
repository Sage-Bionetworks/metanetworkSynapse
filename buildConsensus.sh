#!/bin/sh


Rscript $pathv/buildConsensus.R $dataFile $outputpath $networkFolderId $provenanceFile
#compute md5

provenanceFileUpdated=$outputpath/rankConsensusProvenanceFile.txt

Rscript $pathv/computeMD5.R $outputpath/rankConsensusNetwork.csv $outputpath/rankconsensustempmd5.out
#push to s3

aws s3 mv $outputpath/rankConsensusNetwork.csv $s3
#link file to synapse, add provenance, add annotations

Rscript $pathv/s3LinkToSynapse.R $s3b/rankConsensusNetwork.csv $outputpath/rankconsensustempmd5.out $parentId $annotationFile $provenanceFileUpdated "rankConsensus"