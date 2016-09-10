aws s3 mv $outputpath/genie3Network.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/genie3Network.csv $outputpath/genie3tempmd5.out $parentId $annotationFile $provenanceFile $bucket "genie3"
