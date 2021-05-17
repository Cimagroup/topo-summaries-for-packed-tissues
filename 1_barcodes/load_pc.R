load_pc <- function(cellNumber){
#------------------------------------------------------------------------------
# input: the set of numbers of cells per image in the experiment [cellNumbers]
#
# output: read all point clouds in txt format and save them in pcList.
# pcList[[j]] correspond with the dataName[j] 
#------------------------------------------------------------------------------
# author: M. Soriano-Trigueros - msroaino4@us.es, 2021.
#------------------------------------------------------------------------------

  pcList <- list()
  
    path <- paste('../0_data','point_clouds', as.character(cellNumber),
                  sep = '/')
    dataNames <- list.files(path)
    pcList <- list()
    for (j in seq(1,length(dataNames))){
      pcList[[j]] <- read.table(paste(path, dataNames[j], sep = '/'))
    }

  return(list(pcList, dataNames))
}
