normaL1 <- function(map, domain){
  n <- length(domain)
  base <- domain[seq(2,n,1)] - domain[seq_len(n-1)]
  height <- abs(map[seq(2,n,1)] + map[seq_len(n-1)])/2
  norma <- sum(base*height)
  return(norma)
}
