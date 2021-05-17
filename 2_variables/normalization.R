normalization <- function(barcode, dimension = -1){
  
#------------------------------------------------------------------------------
# input: a [barcode] with the dimension of the bars in the first row and birth 
# and death time in the second and third. The [dimension] of the barcode we
# want to work with, -1 if we consider the whole barcode.
#
# output: barcode with only bars of the fixed dimension and for which the sum 
# of all lengths is 1.
#------------------------------------------------------------------------------

  if (dimension > -1 ){
    validIntervals <- which(barcode[, 1] == dimension)
    n <- length(validIntervals)
  } else {
    n <- dim(barcode)[1]
    validIntervals <- 1 : n
  }
  if (n == 0){
    return(c(NaN,0,0))
    break
  } else {
    barsLength <- barcode[validIntervals, 3] - barcode[validIntervals, 2]
    L <- sum(barsLength)
  }
  newBarcode <- barcode[validIntervals, ]
  newBarcode[, c(2,3)] <- newBarcode[, c(2,3)]/L
  return(list(newBarcode, L, n))
}
