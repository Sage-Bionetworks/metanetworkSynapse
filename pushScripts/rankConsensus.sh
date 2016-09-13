#!/bin/sh
aws s3 mv $outputpath/rankConsensusNetwork.csv $s3
provenanceFileUpdated=$outputpath/rankConsensusProvenanceFile.txt
Rscript $pathv/s3LinkToSynapse.R $s3b/rankConsensusNetwork.csv $outputpath/rankconsensustempmd5.out $parentId $annotationFile $provenanceFileUpdated $bucket "rankConsensus"

