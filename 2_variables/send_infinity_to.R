send_infinty_to <- function(barcode, value=0, maxscale = 'Inf'){
#------------------------------------------------------------------------------
# input: a [barcode] with the dimension of the bars in the first row and birth 
# and death time in the second and third. The [value] we want to
# replace [maxscale] by. Usually [maxscale] is the infinity value.
#
# output: a barcode with infinity changed by [value] in bars where the 
# birthtime is greater than [value] or changed by the birthtime otherwise
#------------------------------------------------------------------------------


  infty.intervals <- which(barcode[, 3] == maxscale)
  for (i in infty.intervals){
    if (barcode[i,2] > value){
      barcode[i,3] <- barcode[i,2]
    } else {
      barcode[i,3] <- value
    }
  }
  return(barcode)
}