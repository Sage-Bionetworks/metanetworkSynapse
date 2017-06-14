# Function to make submission scripts for consensus module generation with sge

#### Get inputs ####
bic.net.ids = c(ROSMAP = 'syn8268669', MayoRNAseq.TCX = 'syn8276546', MayoRNAseq.CBE = 'syn8281722', MSBB.IFG = 'syn8349785', 
                MSBB.PHG = 'syn8345109', MSBB.STG = 'syn8343704', MSBB.FP = 'syn8340017', MayoEGWAS.TCX = 'syn8419174',
                MayoEGWAS.CBE = 'syn8421913')

rankCons.net.ids = c(ROSMAP = 'syn8268680', MayoRNAseq.TCX = 'syn8276556', MayoRNAseq.CBE = 'syn8281727',  MSBB.IFG = 'syn8349787',
                     MSBB.PHG = 'syn8345270', MSBB.STG = 'syn8343716', MSBB.FP = 'syn8340019', MayoEGWAS.TCX = 'syn8419231',
                     MayoEGWAS.CBE = 'syn8421921')

module.folder.ids = c(ROSMAP = 'syn8399110', MayoRNAseq.TCX = 'syn8508499', MayoRNAseq.CBE = 'syn8548178',  MSBB.IFG = 'syn8619801',
                      MSBB.PHG = 'syn8608724', MSBB.STG = 'syn8615206', MSBB.FP = 'syn8379809', MayoEGWAS.TCX = 'syn8672883',
                      MayoEGWAS.CBE = 'syn8672911')

cons.methods = c('kmeans')
run.id = seq(1,20,1)

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
objs = mapply(function(bicId, rankId, modId, con, modMethods, repositoryName, branchName, fileName, synapseConfigPath, rLibPath, runId){
  obj = mapply(function(modMethods, bicId, rankId, modId, con, repositoryName, branchName, fileName, synapseConfigPath, rLibPath, runId){
    fileId = synQuery(paste('select name,id from folder where parentId == "', modId, '"')) %>%
      dplyr::filter(folder.name %in% c("CFinder", "GANXiS", "label_prop", "fast_greedy", "louvain", "walktrap", "infomap", "spinglass", "linkcommunities")) %>%
      plyr::ddply(.(folder.name), .fun = function(fld){
        synQuery(paste('select name,id,method,Q,Qds from file where parentId == "', fld$folder.id, '" and analysisType == "moduleIdentification"'))
      }) %>%
      dplyr::group_by(file.method) %>%
      dplyr::mutate(rank = rank(rank(as.numeric(file.Q))+rank(as.numeric(file.Qds)))) %>%
      dplyr::top_n(1, rank) %>%
      dplyr::slice(1)
                         
    tmp.modId = paste(fileId$file.id, collapse = ' ')
    
    for (i in runId){
      fp1 = file(paste0('./submission.scripts/', 
                        bicId, '.', 
                        rankId, '.', 
                        modId, '.', 
                        modMethods, '.',
                        i, '.sh'), 
                 open = 'w+')
    writeLines('#!/bin/bash', con = fp1, sep = '\n')
    writeLines(paste('Rscript -e "source(\'buildConsensusModules.R\')"', 
                     modMethods, 
                     i,
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
                     '-o', paste0('./submission.scripts/', bicId, '.', rankId, '.', modId, '.', modMethods, '.', i, '.out'),
                     '-e', paste0('./submission.scripts/', bicId, '.', rankId, '.', modId, '.', modMethods, '.', i, '.err'), 
                     paste0('./submission.scripts/', bicId, '.', rankId, '.', modId, '.', modMethods, '.', i, '.sh')),
               con = con, sep = '\n')
    }
  }, 
  modMethods, 
  MoreArgs = list(bicId, rankId, modId, con, repositoryName, branchName, fileName, synapseConfigPath, rLibPath, runId), 
  SIMPLIFY = FALSE)
}, 
bic.net.ids, 
rankCons.net.ids, 
module.folder.ids,
MoreArgs = list(con = fp, modMethods = cons.methods, repositoryName = repository.name, branchName = branch.name, fileName = file.name, synapseConfigPath = synapse.config.path, rLibPath = r.library.path, runId = run.id),
SIMPLIFY = FALSE)

close(fp)
