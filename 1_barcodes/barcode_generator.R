barcode_generator <- function(cellNumber, pcList, dataNames){
#------------------------------------------------------------------------------
# input: the set of numbers of cells per image in the experiment [cellNumbers],
# a list with all point clouds for each numbers of cells [pcList] and the name
# of all data files [dataNames]
#
# output: take barcodes in pcList and save them as text files. It
# returns a list of barcodes [barcodeList] where barcodeList[[j]]
# correspond with the point cloud pcList[[j]]. It also save the normalized
# barcodes as images.  
#------------------------------------------------------------------------------

  require("TDA")
  require("MASS")
  barcodesList <- list()
  
  path <- paste('barcodes_txt', as.character(cellNumber), 'rips/',
                sep = '/')
  path2 <- paste('barcodes_png', as.character(cellNumber), 'rips/',
                sep = '/')
  dir.create(file.path(path), showWarnings = FALSE)
  dir.create(file.path(paste("barcodes_png", 
                             as.character(cellNumber), sep = "/")),
             showWarnings = FALSE)
  dir.create(file.path(path2), showWarnings = FALSE)
  
  for (j in seq(length(dataNames))){
    aux <- ripsDiag(X = pcList[[j]], maxdimension = 0, maxscale = 150,
                    library = c("GUDHI", "Dionysus"))
    barcodesList[[j]] <- aux[[1]]
    
    n <- nchar(dataNames[j])
    path3 <- substr(dataNames[j], 1, n-6)
    
    png(filename = paste(path2, path3, "bar.png", sep = ""))
    plot.diagram((aux[["diagram"]][-1,]/
            sum(aux[["diagram"]][-1,3] - aux[["diagram"]][-1,2])), 
         barcode = TRUE)
    dev.off()
    aux <- matrix(aux[["diagram"]], dim(aux[["diagram"]]))
    write.matrix(aux,
                file = paste(path, path3, "bar.txt", sep = ""))
  }
    
  
  return(barcodesList)
}