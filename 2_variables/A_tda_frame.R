#------------------------------------------------------------------------------
#  We create a frame with the following variables, where n is the dimension of
#  the barcode and filt its filtration:
#  - type -> the type of cell.
#  - PE.n.filt -> persistent entropy.
#  - landscape.n.k.filt -> the norm of the landscape of parameteter k 
#  - lan.n.p.filt ->  the norm of the landscape of parameteter k=cellNumber*p
#  - max.n.m.k.filt -> max(dm +...+d(k+m-1)) where di = yi - xi sorted in
#  decreasing order
#  - MAX.n.m.p.filt -> max(dm +...+d(k+m-1)) where k = cellNumber*p, 
#  di = yi - xi sorted in decreasing order
#  - len.k -> the length of the n-th longest bar (we only use it in the
#    rips complex)
#  - LEN.p -> the length of the (cellNumber*p)-th longest bar (we only use it 
#    in the rips complex)
# Save it as frames/cells_frame.RData
#------------------------------------------------------------------------------

require("TDA")
source("normalization.R")
source("send_infinity_to.R")
source("shannon.R")
source("normaL1.R")

cellNumber <- 187

val02 <- floor(cellNumber*0.02)
val03 <- floor(cellNumber*0.03)
val05 <- floor(cellNumber*0.05)
val10 <- floor(cellNumber*0.1)
val15 <- floor(cellNumber*0.15)
val20 <- floor(cellNumber*0.2)
val50 <- floor(cellNumber*0.5)


#####  SUB FILTRATION ####

#Load barcodes from the sub filtration
barcodesList <- list()
path <- paste('../1_barcodes/barcodes_txt',as.character(cellNumber),'sub', sep ="/")
dataNames <- list.files(path)
aux <- list()
for (j in seq(1,length(dataNames))){
  aux <- read.table(paste(path, dataNames[j], sep = '/'))
  barcodesList <- c(barcodesList, list(aux))
}

#Calculate the type of the cells
type <- c()
for (name in dataNames){
  n <- nchar(name)
  if (n == 21){
    aux <- substr(name, 1, 6)
  } else if (n == 18) {
    aux <- substr(name, 1, 3)
  }
  type <- c(type, aux)
}

# Separate the barcodes by dimension
barcodesList0 <- list()
barcodesList1 <- list()
for (j in seq(length(barcodesList))){
  aux <- barcodesList[[j]][which(barcodesList[[j]][, 1] == 0),]
  barcodesList0 <- c(barcodesList0, list(aux))
  aux <- barcodesList[[j]][which(barcodesList[[j]][, 1] == 1),]
  barcodesList1 <- c(barcodesList1, list(aux))
}

# Send the endpoints of the infinity bars to 15
for (j in seq(length(barcodesList0))){
  barcodesList0[[j]] <- send_infinty_to(barcodesList0[[j]], value = 15)
  barcodesList1[[j]] <- send_infinty_to(barcodesList1[[j]], value = 15)
}

#Calculate the variable for the sub filtration
PE.0.sub <- c()
PE.1.sub <- c()

landscape.0.2.sub <- c()
landscape.0.5.sub <- c()
lan.0.05.sub <- c()
lan.0.10.sub <- c()
lan.0.15.sub <- c()

landscape.1.1.sub <- c()
landscape.1.2.sub <- c()
lan.1.03.sub <- c()
lan.1.05.sub <- c()


max.0.1.1.sub <- c()
max.0.1.2.sub <- c()
max.0.1.3.sub <- c()
max.0.2.1.sub <- c()
max.0.2.2.sub <- c()
max.0.2.3.sub <- c()
MAX.0.2.10.sub <- c()

max.1.1.1.sub <- c()
max.1.2.1.sub <- c()
max.1.1.2.sub <- c()
MAX.1.1.02.sub <- c()
MAX.1.1.03.sub <- c()


for (j in seq(length(dataNames))){
  barcodeAux0 <- barcodesList0[[j]]
  barcodeAux1 <- barcodesList1[[j]]
  
  #Calculate persistent entropy
  L0 <- sum(barcodeAux0[, 3] - barcodeAux0[, 2])
  L1 <- sum(barcodeAux1[, 3] - barcodeAux1[, 2])
  
  PE.0.sub <- c(PE.0.sub, shannon((barcodeAux0[, 3] - barcodeAux0[, 2])/L0))
  PE.1.sub <- c(PE.1.sub, shannon((barcodeAux1[, 3] - barcodeAux1[, 2])/L1))
  
  #The domain in this filtration are the integer from 0 to 15:
  dom <- seq(0, 15, 0.1)
  #Calculate the norm of the landscapes of barcodes of dim 0
  #aux <- normaL1(landscape(barcodeAux0, dimension=0, KK=1, dom), dom)
  aux <- normaL1(landscape(barcodeAux0, dimension=0, KK=2, dom), dom)
  landscape.0.2.sub <- c(landscape.0.2.sub, aux)
  aux <- normaL1(landscape(barcodeAux0, dimension=0, KK=5, dom), dom)
  landscape.0.5.sub <- c(landscape.0.5.sub, aux)
  aux <- normaL1(landscape(barcodeAux0, dimension=0, KK=val05, dom), dom)
  lan.0.05.sub <- c(lan.0.05.sub, aux)
  aux <- normaL1(landscape(barcodeAux0, dimension=0, KK=val10, dom), dom)
  lan.0.10.sub <- c(lan.0.10.sub, aux)
  aux <- normaL1(landscape(barcodeAux0, dimension=0, KK=val15, dom), dom)
  lan.0.15.sub <- c(lan.0.15.sub, aux)
  
  #Calculate the norm of the landscapes of barcodes of dim 1
  aux <- normaL1(landscape(barcodeAux1, dimension=1, KK=1, dom), dom)
  landscape.1.1.sub <- c(landscape.1.1.sub, aux)
  aux <- normaL1(landscape(barcodeAux1, dimension=1, KK=2, dom), dom)
  landscape.1.2.sub <- c(landscape.1.2.sub, aux)
  aux <- normaL1(landscape(barcodeAux1, dimension=1, KK=val03, dom), dom)
  lan.1.03.sub <- c(lan.1.03.sub, aux)
  aux <- normaL1(landscape(barcodeAux1, dimension=1, KK=val05, dom), dom)
  lan.1.05.sub <- c(lan.1.05.sub, aux)
  
  #Calculate the maximum of the lengths
  aux = max(barcodeAux0[, 3] - barcodeAux0[, 2])
  max.0.1.1.sub <- c(max.0.1.1.sub, aux)
  sortedAux <- sort(barcodeAux0[, 3] - barcodeAux0[, 2], decreasing = TRUE)
  aux = sum(sortedAux[c(1,2)])
  max.0.1.2.sub <- c(max.0.1.2.sub, aux)
  aux = sum(sortedAux[seq(1, 3)])
  max.0.1.3.sub <- c(max.0.1.3.sub, aux)
  aux = sum(sortedAux[2])
  max.0.2.1.sub <- c(max.0.2.1.sub, aux)
  aux = sum(sortedAux[c(2,3)])
  max.0.2.2.sub <- c(max.0.2.2.sub, aux)
  aux = sum(sortedAux[seq(2, 4)])
  max.0.2.3.sub <- c(max.0.2.3.sub, aux)
  aux = sum(sortedAux[seq(2, val10+1)])
  MAX.0.2.10.sub <- c(MAX.0.2.10.sub, aux)
  
  aux = max(barcodeAux1[, 3] - barcodeAux1[, 2])
  max.1.1.1.sub <- c(max.1.1.1.sub, aux)
  sortedAux <- sort(barcodeAux1[, 3] - barcodeAux1[, 2], decreasing = TRUE)
  aux <- sortedAux[1] + sortedAux[2]
  max.1.1.2.sub <- c(max.1.1.2.sub, aux)
  aux <- sortedAux[2]
  max.1.2.1.sub <- c(max.1.2.1.sub, aux)
  aux <- sum(sortedAux[seq(1, val02)])
  MAX.1.1.02.sub <- c(MAX.1.1.02.sub, aux)
  aux <- sum(sortedAux[seq(1, val03)])
  MAX.1.1.03.sub <- c(MAX.1.1.03.sub, aux)
}

#####  SUP FILTRATION  #####


#Load barcodes from the sup filtration
barcodesList <- list()
path <- paste('../1_barcodes/barcodes_txt',as.character(cellNumber),'sup', 
              sep ="/")
dataNames <- list.files(path)
aux <- list()
for (j in seq(1,length(dataNames))){
  aux <- read.table(paste(path, dataNames[j], sep = '/'))
  barcodesList <- c(barcodesList, list(aux))
}


# Separate the barcodes by dimension
barcodesList0 <- list()
barcodesList1 <- list()
for (j in seq(length(barcodesList))){
  aux <- barcodesList[[j]][which(barcodesList[[j]][, 1] == 0),]
  barcodesList0 <- c(barcodesList0, list(aux))
  aux <- barcodesList[[j]][which(barcodesList[[j]][, 1] == 1),]
  barcodesList1 <- c(barcodesList1, list(aux))
}

# Send the endpoints of the infinity bars to 15
for (j in seq(length(barcodesList0))){
  barcodesList0[[j]] <- send_infinty_to(barcodesList0[[j]], value = 15)
  barcodesList1[[j]] <- send_infinty_to(barcodesList1[[j]], value = 15)
}

#Calculate the variable for the sup filtration
PE.0.sup <- c()
PE.1.sup <- c()

landscape.0.2.sup <- c()
lan.0.02.sup <- c()
lan.0.03.sup <- c()
landscape.1.1.sup <- c()
landscape.1.2.sup <- c()
lan.1.02.sup <- c()

max.0.1.1.sup <- c()
max.0.1.2.sup <- c()
MAX.0.1.02.sup <- c()
max.0.2.1.sup <- c()
max.0.2.2.sup <- c()
MAX.0.2.02.sup <- c()
max.1.1.1.sup <- c()
max.1.2.1.sup <- c()
MAX.1.2.02.sup <- c()
MAX.1.1.02.sup <- c()



for (j in seq(length(dataNames))){
  barcodeAux0 <- barcodesList0[[j]]
  barcodeAux1 <- barcodesList1[[j]]
  
  #Calculate persistent entropy
  L0 <- sum(barcodeAux0[, 3] - barcodeAux0[, 2])
  L1 <- sum(barcodeAux1[, 3] - barcodeAux1[, 2])
  
  PE.0.sup <- c(PE.0.sup, shannon((barcodeAux0[, 3] - barcodeAux0[, 2])/L0))
  PE.1.sup <- c(PE.1.sup, shannon((barcodeAux1[, 3] - barcodeAux1[, 2])/L1))
  
  #The domain in this filtration are the integer from 0 to 15:
  dom <- seq(0, 15, 0.1)
  #Calculate the norm of the landscapes of barcodes of dim 0
  aux <- normaL1(landscape(barcodeAux0, dimension=0, KK=2, dom), dom)
  landscape.0.2.sup <- c(landscape.0.2.sup, aux)
  aux <- normaL1(landscape(barcodeAux0, dimension=0, KK=val02, dom), dom)
  lan.0.02.sup <- c(lan.0.02.sup, aux)
  aux <- normaL1(landscape(barcodeAux0, dimension=0, KK=val03, dom), dom)
  lan.0.03.sup <- c(lan.0.03.sup, aux)
  
  #Calculate the norm of the landscapes of barcodes of dim 1
  aux <- normaL1(landscape(barcodeAux1, dimension=1, KK=1, dom), dom)
  landscape.1.1.sup <- c(landscape.1.1.sup, aux)
  aux <- normaL1(landscape(barcodeAux1, dimension=1, KK=2, dom), dom)
  landscape.1.2.sup <- c(landscape.1.2.sup, aux)
  aux <- normaL1(landscape(barcodeAux1, dimension=1, KK=val02, dom), dom)
  lan.1.02.sup <- c(lan.1.02.sup, aux)
  
  aux <- max(barcodeAux0[, 3] - barcodeAux0[, 2])
  max.0.1.1.sup <- c(max.0.1.1.sup, aux)
  sortedAux <- sort(barcodeAux0[, 3] - barcodeAux0[, 2], decreasing = TRUE)
  aux <- sortedAux[1] + sortedAux[2]
  max.0.1.2.sup <- c(max.0.1.2.sup, aux)
  aux <- sum(sortedAux[seq(1,val02)])
  MAX.0.1.02.sup <- c(MAX.0.1.02.sup, aux)
  aux <- sortedAux[2]
  max.0.2.1.sup <- c(max.0.2.1.sup, aux)
  aux <- aux + sortedAux[3]
  max.0.2.2.sup <- c(max.0.2.2.sup, aux)
  aux <- sum(sortedAux[seq(2,val02+1)])
  MAX.0.2.02.sup <- c(MAX.0.2.02.sup, aux)
  
  sortedAux <- sort(barcodeAux1[, 3] - barcodeAux1[, 2], decreasing = TRUE)
  aux <- sortedAux[1]
  max.1.1.1.sup <- c(max.1.1.1.sup, aux)
  aux <- sortedAux[2]
  max.1.2.1.sup <- c(max.1.2.1.sup, aux)
  aux <- sum(sortedAux[seq(2,val02+1)])
  MAX.1.2.02.sup <- c(MAX.1.2.02.sup, aux)
  aux <- sum(sortedAux[seq(1,val02+1)])
  MAX.1.1.02.sup <- c(MAX.1.1.02.sup, aux)
}


#####  ALPHA FILTRATION ####
#Load barcodes from the sup filtration
path <- paste('../1_barcodes/barcodes_txt',as.character(cellNumber),'rips', 
              sep ="/")
barcodesList <- readRDS(file = paste(path, "rips_barcodes.rds", sep="/"))

#Remove the infinity bar. Note that for the rips complex we fixed the maxscale
#in 150 not infinity in barcode_generator.
for (j in seq(length(barcodesList))){
  barcodesList[[j]] <- send_infinty_to(barcodesList[[j]], value = 0, maxscale = 150)
}

# Normalize the barcodes of dimension 0
barcodesList0 <- list()
for (j in seq(length(barcodesList))){
  aux <- normalization(barcodesList[[j]], dimension = 0)[1]
  barcodesList0 <- c(barcodesList0, aux)
}

# Calculate the maximum death value
max0 <- c()
for (j in seq(length(barcodesList0))){
  max0 <- c(max0, max(barcodesList0[[j]][,3]))
}
max0 <- max(max0)

#Calculate the variable for the rips filtration
PE.0.rips <- c()


len.1 <- c()
len.2 <- c()
len.5 <- c()
LEN.05 <- c()
LEN.10 <- c()
LEN.15 <- c()
LEN.20 <- c()
LEN.50 <- c()


max.0.1.1.rips <- c()
max.0.1.2.rips <- c()
max.0.1.3.rips <- c()
MAX.0.1.05.rips <- c()
MAX.0.1.10.rips <- c()
MAX.0.1.20.rips <- c()
MAX.0.1.50.rips <- c()

for (j in seq(length(dataNames))){
  barcodeAux0 <- barcodesList0[[j]]
  
  #Calculate persistent entropy
  L0 <- sum(barcodeAux0[, 3] - barcodeAux0[, 2])
  
  PE.0.rips <- c(PE.0.rips, shannon((barcodeAux0[, 3] - barcodeAux0[, 2])/L0))
  
  
  #Calculate the maximum of the lengths
  sortedAux <- sort(barcodeAux0[, 3] - barcodeAux0[, 2], decreasing = TRUE)
  
  aux <- sortedAux[1]
  len.1 <- c(len.1, aux)
  aux <- sortedAux[2]
  len.2 <- c(len.2, aux)
  aux <- sortedAux[5]
  len.5 <- c(len.5, aux)
  aux <- sortedAux[val05]
  LEN.05 <- c(LEN.05, aux)
  aux <- sortedAux[val10]
  LEN.10 <- c(LEN.10, aux)
  aux <- sortedAux[val15]
  LEN.15 <- c(LEN.15, aux)
  aux <- sortedAux[val20]
  LEN.20 <- c(LEN.20, aux)
  aux <- sortedAux[val50]
  LEN.50 <- c(LEN.50, aux)
  
  aux <- sortedAux[1]
  max.0.1.1.rips <- c(max.0.1.1.rips, aux)
  aux<- sortedAux[1] + sortedAux[2]
  max.0.1.2.rips <- c(max.0.1.2.rips, aux)
  aux<-aux + sortedAux[3]
  max.0.1.3.rips <- c(max.0.1.3.rips, aux)
  aux <- sum(sortedAux[seq(1, val05)])
  MAX.0.1.05.rips <- c(MAX.0.1.05.rips, aux)
  aux <- sum(sortedAux[seq(1, val10)])
  MAX.0.1.10.rips <- c(MAX.0.1.10.rips, aux)
  aux <- sum(sortedAux[seq(1, val20)])
  MAX.0.1.20.rips <- c(MAX.0.1.20.rips, aux)
  aux <- sum(sortedAux[seq(1, val50)])
  MAX.0.1.50.rips <- c(MAX.0.1.50.rips, aux)
}


cells_frame <- data.frame(type, PE.0.sub, PE.1.sub, landscape.0.2.sub, 
                          landscape.0.5.sub, lan.0.05.sub, lan.0.10.sub, 
                          lan.0.15.sub, landscape.1.1.sub, landscape.1.2.sub, 
                          lan.1.03.sub, lan.1.05.sub, max.0.1.1.sub,
                          max.0.1.2.sub, max.0.1.3.sub, max.0.2.1.sub, 
                          max.0.2.2.sub, max.0.2.3.sub,   MAX.0.2.10.sub, 
                          max.1.1.1.sub, max.1.2.1.sub, max.1.1.2.sub,  
                          MAX.1.1.02.sub, MAX.1.1.03.sub, PE.0.sup, PE.1.sup,  
                          landscape.0.2.sup, lan.0.02.sup, lan.0.03.sup,  
                          landscape.1.1.sup, landscape.1.2.sup, lan.1.02.sup, 
                          max.0.1.1.sup, max.0.1.2.sup, MAX.0.1.02.sup,  
                          max.0.2.1.sup, max.0.2.2.sup, MAX.0.2.02.sup, 
                          max.1.1.1.sup, max.1.2.1.sup, MAX.1.1.02.sup,
                          MAX.1.2.02.sup, PE.0.rips, len.1, len.2, len.5,
                          LEN.15, LEN.20, LEN.50, max.0.1.1.rips, LEN.05, 
                          LEN.10, max.0.1.2.rips, max.0.1.3.rips, 
                          MAX.0.1.05.rips, MAX.0.1.10.rips, MAX.0.1.20.rips,
                          MAX.0.1.50.rips)

path <- paste("frames", as.character(cellNumber), sep="/")
dir.create(path,  showWarnings = FALSE)
save(cells_frame, file = paste(path, "cells_frame.RData", sep="/"))


