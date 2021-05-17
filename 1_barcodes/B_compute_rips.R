#------------------------------------------------------------------------------
# This script generates the barcodes from the rips complex filtration.
# Save them in barcodes/"cell_number"/ and their images in 
# barcodes_png/"cell_number"/
#------------------------------------------------------------------------------


require("TDA")
require("MASS")
source("load_pc.R")
source("barcode_generator.R")

cellNumber <- 187

aux <- load_pc(cellNumber)
pcList <- aux[[1]]
dataNames <- aux[[2]]

barcodesList <- barcode_generator(cellNumber, pcList, dataNames)

saveRDS(barcodesList, paste('barcodes_txt', as.character(cellNumber),'rips',
                            'rips_barcodes.rds', sep ='/'))
