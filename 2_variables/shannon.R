shannon <- function(probabilities, normalized = FALSE){
#------------------------------------------------------------------------------
# input: a vector of [probabilities] and a boolean denoting if we want the 
# [normalized] entropy.
#
# output: the shannon entropy of the vector of probabilities.
#------------------------------------------------------------------------------

  
  #since 0*log0 = 0 = 1*log(1), we change 0s by 1s to avoid error
  probabilities[probabilities == 0] <- 1
  if (all(is.nan(probabilities))){
    return(0)
  } else {
    E <- -sum(probabilities*log2(probabilities))
    if (normalized){
      return(E/length(probabilities))
    } else {
      return(E)
    }
  }
}