# Function to make submission scripts for consensus module generation with sge

#### Get inputs ####
bic.net.ids = c(MayoRNAseq.TCX = 'syn8276546', MayoRNAseq.CBE = 'syn8281722', MSBB.IFG = 'syn8349785', 
                MSBB.PHG = 'syn8345109', MSBB.STG = 'syn8343704', MSBB.FP = 'syn8340017', MayoEGWAS.TCX = 'syn8419174',
                MayoEGWAS.CBE = 'syn8421913')

rankCons.net.ids = c(MayoRNAseq.TCX = 'syn8276556', MayoRNAseq.CBE = 'syn8281727',  MSBB.IFG = 'syn8349787',
                     MSBB.PHG = 'syn8345270', MSBB.STG = 'syn8343716', MSBB.FP = 'syn8340019', MayoEGWAS.TCX = 'syn8419231',
                     MayoEGWAS.CBE = 'syn8421921')

module.folder.ids = c(MayoRNAseq.TCX = 'syn8508499', MayoRNAseq.CBE = 'syn8548178',  MSBB.IFG = 'syn8619801',
                      MSBB.PHG = 'syn8608724', MSBB.STG = 'syn8615206', MSBB.FP = 'syn8379809', MayoEGWAS.TCX = 'syn8672883',
                      MayoEGWAS.CBE = 'syn8672911')

cons.methods = c('kmeans')

repository.name = 'th1vairam/metanetworkSynapse'
branch.name = 'modules_dev'
file.name = 'buildModules.R'  

synapse.config.path = '/shared/synapseConfig'
r.library.path = '/shared/rlibs'

# Make submission directory
system('rm -rf ./submission.scripts')
system('mkdir ./submission.scripts')

# Open a master template file to store submission commands to sge
fp = file('./submission.modules.sh', open = 'w+')
writeLines('#!/bin/bash', con = fp, sep = '\n')

# Create submission scripts for each network each method
objs = mapply(function(bicId, rankId, modId, con, modMethods, repositoryName, branchName, fileName, synapseConfigPath, rLibPath){
  obj = mapply(function(modMethods, bicId, rankId, modId, con, repositoryName, branchName, fileName, synapseConfigPath, rLibPath){
    tmp = synQuery(paste('select name,id from file where parentId == "', modId, '" and analysisType == "moduleIdentification"'))
    tmp.modId = paste(tmp$file.id, collapse = ' ')
    
    fp1 = file(paste0('./submission.scripts/', 
                      bicId, '.', 
                      rankId, '.', 
                      modId, '.', 
                      modMethods, '.sh'), 
               open = 'w+')
    writeLines('#!/bin/bash', con = fp1, sep = '\n')
    writeLines(paste('Rscript -e "source(\'buildConsensusModules.R\')"', 
                     modMethods, 
                     repositoryName, 
                     branchName, 
                     fileName, 
                     synapseConfigPath, 
                     rLibPath, 
                     bicId, 
                     rankId, 
                     tmp.modId), 
               con = fp1, sep = '\n')
    close(fp1)
    
    writeLines(paste('qsub -cwd -V',
                     '-pe mpi 4',
                     '-o', paste0('./submission.scripts/', bicId, '.', rankId, '.', modId, '.', modMethods, '.out'),
                     '-e', paste0('./submission.scripts/', bicId, '.', rankId, '.', modId, '.', modMethods, '.err'), 
                     paste0('./submission.scripts/', bicId, '.', rankId, '.', modId, '.', modMethods, '.sh')),
               con = con, sep = '\n')
  }, 
  modMethods, 
  MoreArgs = list(bicId, rankId, modId, con, repositoryName, branchName, fileName, synapseConfigPath, rLibPath), 
  SIMPLIFY = FALSE)
}, 
bic.net.ids, 
rankCons.net.ids, 
module.folder.ids,
MoreArgs = list(con = fp, modMethods = cons.methods, repositoryName = repository.name, branchName = branch.name, fileName = file.name, synapseConfigPath = synapse.config.path, rLibPath = r.library.path),
SIMPLIFY = FALSE)

close(fp)
