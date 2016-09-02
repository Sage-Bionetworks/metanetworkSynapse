aws s3 mv $outputpath/rankConsensusNetwork.csv $s3

provenanceFileUpdated=$outputpath/rankConsensusProvenanceFile.txt

#link file to synapse, add provenance, add annotations
Rscript $pathv/s3LinkToSynapse.R $s3b/rankConsensusNetwork.csv $outputpath/rankconsensustempmd5.out $parentId $annotationFile $provenanceFileUpdated "rankConsensus"

aws s3 mv $outputpath/bicNetworks.rda $s3

Rscript $pathv/s3LinkToSynapse.R $s3b/bicNetworks.rda $outputpath/bicnetworkstempmd5.out $parentId $annotationFile $provenanceFileUpdated "bic"
