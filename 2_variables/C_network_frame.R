#------------------------------------------------------------------------------
# Read the txt files in network_variables/ and save the data in 
# frames/network_frame.RDATA
#------------------------------------------------------------------------------

cellNumber <- 187

#Load network
networkList <- c()
path <- paste('network_variables',as.character(cellNumber), sep ="/")
dataNames <- list.files(path)

for (j in seq(1,length(dataNames))){
  aux <- read.table(paste(path, dataNames[j], sep = '/'))
  networkList[j] <- aux
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

mean_degree <- c()
var_degree <- c()
amount_2 <- c()
amount_3 <- c()
amount_4 <- c()
amount_5 <- c()
amount_6 <- c()
amount_7 <- c()
amount_8 <- c()
amount_9 <- c()
amount_10 <- c()
amount_11 <- c()
amount_12 <- c()
amount_13 <- c()

for (j in seq(1,length(dataNames))){
  mean_degree <- c(mean_degree, networkList[[j]][1])
  var_degree <- c(var_degree,  networkList[[j]][2])
  amount_2 <- c(amount_3,  networkList[[j]][3])
  amount_3 <- c(amount_3,  networkList[[j]][4])
  amount_4 <- c(amount_4,  networkList[[j]][5])
  amount_5 <- c(amount_5,  networkList[[j]][6])
  amount_6 <- c(amount_6,  networkList[[j]][7])
  amount_7 <- c(amount_7,  networkList[[j]][8])
  amount_8 <- c(amount_8,  networkList[[j]][9])
  amount_9 <- c(amount_9,  networkList[[j]][10])
  amount_10 <- c(amount_10,  networkList[[j]][11])
  amount_11 <- c(amount_11,  networkList[[j]][12])
  amount_12 <- c(amount_12,  networkList[[j]][13])
  amount_13 <- c(amount_13,  networkList[[j]][14]) 
}

network_frame <- data.frame(type, mean_degree, var_degree,
                            amount_2, amount_3, amount_4, amount_5, 
                            amount_6, amount_7, amount_8, amount_9,
                            amount_10, amount_11, amount_12, amount_13)

path <- paste("frames", as.character(cellNumber), sep="/")
dir.create(path,  showWarnings = FALSE)
save(network_frame, file = paste(path, "network_frame.RData", sep="/"))

