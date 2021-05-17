#------------------------------------------------------------------------------
# Calculate the boxplot of each of the variable in cell_frame and network_frame
#
# The code is divided in three parts: in EPITHELIAL we draw the cell_frame  
# variables of the epithelial tissues; in CVT vs EPITHELIAL the comparison of 
# the cell_frame variables between a step in the CVT path and its epithelial
# counterpart; in NETWORK we plot the network variables in epithelial tissues.
# Files are saved in /boxplots
#------------------------------------------------------------------------------

require("ggplot2")

cellNumber <- 187
load(paste("../2_variables/frames",as.character(cellNumber), "cells_frame.RData", sep="/"))
colNames <- colnames(cells_frame)

#EPITHELIAL

#cell_types are the different epithelium appearing in cell_frame
#cell_types <- c('cEE', 'cNT', 'dNP', 'dWP', 'dWL')
cell_types <- c('dWL', 'dWP')
cond <- is.element(cells_frame$type, cell_types)

#colors used for the boxplot: note that the order matters
color_list <- c("orange", "cyan", "darkolivegreen1", "green", "red")

path <- paste("boxplots/", as.character(cellNumber), "/", sep = "")
dir.create(path,  showWarnings = FALSE)


for (j in seq(2,length(cells_frame))){
  
  fig <- ggplot(cells_frame[cond, ], aes_string(x = 'type', y = colNames[j], colour = 'type'))+
    geom_boxplot()+
    labs(x = "", y = "")+
    ggtitle(colNames[j])+
    theme(legend.position="none",
          plot.title=element_text(size=15))+
    scale_color_manual(values=color_list[seq(1,length(cell_types))])
  
  
  ggsave(paste(path, colNames[j], ".png", sep=""), plot = fig)
}

#CVT vs EPITHELIAL

for (colName in colNames){
  cond <- cells_frame$type == 'cNT' | cells_frame$type == 'CVT001'
  fig <- ggplot(cells_frame[cond, ], aes_string(x = 'type', y = colName, colour = 'type'))+
    geom_boxplot()+
    labs(x = "", y = "")+
    ggtitle(colName)+
    theme(legend.position="none",
          plot.title=element_text(size=15))+
    scale_color_manual(values=c("cyan", "grey"))
  
  
  ggsave(paste(path, colName, "_cNTvs001.png", sep=""), plot = fig)
}

for (colName in colNames){
  cond <- cells_frame$type == 'dWL' | cells_frame$type == 'CVT004'
  fig <- ggplot(cells_frame[cond, ], aes_string(x = 'type', y = colName, colour = 'type'))+
    geom_boxplot()+
    labs(x = "", y = "")+
    ggtitle(colName)+
    theme(legend.position="none",
          plot.title=element_text(size=15))+
    scale_color_manual(values=c("green", "grey"))
  
  
  ggsave(paste(path, colName, "_dWLvs004.png", sep=""), plot = fig)
}

for (colName in colNames){
  cond <- cells_frame$type == 'dWP' | cells_frame$type == 'CVT005'
  fig <- ggplot(cells_frame[cond, ], aes_string(x = 'type', y = colName, colour = 'type'))+
    geom_boxplot()+
    labs(x = "", y = "")+
    ggtitle(colName)+
    theme(legend.position="none",
          plot.title=element_text(size=15))+
    scale_color_manual(values=c("red", "grey"))
  
  
  ggsave(paste(path, colName, "_dWPvs005.png", sep=""), plot = fig)
}

# Network variables

load(paste("../2_variables/frames",as.character(cellNumber), "network_frame.RData", sep="/"))
colNames <- colnames(network_frame)
cond <- is.element(network_frame$type, cell_types)

#colors used for the boxplot: note that the order matters
color_list <- c("orange", "cyan", "darkolivegreen1", "green", "red")

path <- paste("boxplots/", as.character(cellNumber), "/", sep = "")
dir.create(path,  showWarnings = FALSE)


for (j in seq(2,length(network_frame))){
  
  fig <- ggplot(network_frame[cond, ], aes_string(x = 'type', y = colNames[j], colour = 'type'))+
    geom_boxplot()+
    labs(x = "", y = "")+
    ggtitle(colNames[j])+
    theme(legend.position="none",
          plot.title=element_text(size=15))+
    scale_color_manual(values=color_list[seq(1,length(cell_types))])
  
  
  ggsave(paste(path, colNames[j], ".png", sep=""), plot = fig)
}
