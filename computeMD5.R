file <- as.character(commandArgs(TRUE)[[1]])
md5outfile <- as.character(commandArgs(TRUE)[[2]])
computeMD5 <- function(file,md5outfile){
  md5Command <- paste0('md5sum ',file)
  md5 <- strsplit(system(md5Command,intern=TRUE),'  ')[[1]][1]
  cat(md5,'\n',file=md5outfile,sep = '')
}
computeMD5(file,md5outfile)