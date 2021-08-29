labrary()

## Input dir
input_dir <- paste0(args[1])

## Output dir
output_dir <- paste0(args[2])

## BPPARAM workers
bw <- as.numeric(paste0(args[3]))

## Load xcmsSet objects into one
input <- list.files(input_dir, pattern=".rds", full.names=TRUE)
input_l <- lapply(input, readRDS)

xset <- input_l[[1]]
for(i in 2:length(input_l)) {
  set <- input_l[[i]]
  xset <- c(xset, set)
  }
  
## Grouping
gset <- group(xset,  , method="density")
save(list=c("gset"), file=paste0(output_dir,"/02.2.1_Grouping-1.RData"))

## RT correction
rset <- retcor.peakgroup(gset, plottype="none", ...)
save(list=c("rset"), file=paste0(output_dir,"/02.2.2_RTcorrection.RData"))

## Grouping No2
grset <- group(rset, method="density", ...)
save(list=c("grset"), file=paste0(output_dir,"/02.2.3_Grouping-2.RData"))

## Filling peaks
fset <- fillPeaks(grset,
                 method="chrom",
                 BPPARAM = MulticoreParm(worker=bw))
save(list=c("fset"), file=paste0(output_dir,"/02.2.4_FillingPeaks.RData"))

Table=peakTable(fset)
write.csv(Table, file=paste0(output_dir, "/02.2.5_Peak_Table_Name.csv"), col.names=FALSE)

