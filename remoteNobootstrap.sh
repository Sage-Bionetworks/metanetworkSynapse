#!/bin/bash

. /shared/metanetworkSynapse/config.sh
# actual network
mkdir -p /shared/network/errorLogs/; mkdir -p /shared/network/outLogs/
cd /shared/network/
git clone https://github.com/philerooski/brainRegNetwork.git
Rscript -e "library(devtools); install_github('blogsdon/utilityFunctions')"
Rscript brainRegNetwork/getData.R $dataSynId
echo "provenance,executed" > /shared/network/provenanceFile.txt
echo "${dataSynId},FALSE" >> /shared/network/provenanceFile.txt
echo "https://github.com/philerooski/brainRegNetwork/blob/master/getData.R,TRUE" >> /shared/network/provenanceFile.txt
echo "https://github.com/Sage-Bionetworks/metanetworkSynapse,TRUE" >> /shared/network/provenanceFile.txt


Rscript -e "library(synapseClient); synapseLogin(); foo = synGet(commandArgs(TRUE)[[1]],downloadFile=FALSE); bar = synGetAnnotations(foo); if(length(bar)>0){baz = data.frame(key= names(bar),value=bar,stringsAsFactors=F); write.table(baz,sep = ',',file='annoFile.txt',quote=F,row.names=FALSE,col.names=FALSE)}else{cat('',file='/shared/network/annoFile.txt')}" $dataSynId

echo -e "fileType,csv\ndataType,analysis\nanalysisType,statisticalNetworkReconstruction\nnormalizationStatus,TRUE" >> /shared/network/annoFile.txt
sh /shared/metanetworkSynapse/submission.sh
