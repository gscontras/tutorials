bootsSummary <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                         conf.interval=.95, .drop=TRUE, n_boots_samps=10000) {
  require(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     bootsci_high = quantile( #doesn't play nice with na.rm
                       replicate(n_boots_samps, mean(sample(xx[[col]], replace = TRUE))),
                       c(0.025, 0.975))[["97.5%"]],
                     bootsci_low = quantile( #doesn't play nice with na.rm
                       replicate(n_boots_samps, mean(sample(xx[[col]], replace = TRUE))),
                       c(0.025, 0.975))[["2.5%"]]
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean" = measurevar))
  
  return(datac)
}
