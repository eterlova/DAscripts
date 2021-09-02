library(data.table)
library(pander)
library(magrittr)
library(SummarizedExperiment)
library(xcms)

args = commandArgs(trailingOnly=TRUE)

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
  
## Grouping for parameters see script 01 or outfiles of that job
#gset <- group(xset,  , method="density")
#save(list=c("gset"), file=paste0(output_dir,"/02.2.1_Grouping-1.RData"))

## RT correction based on groups for parameters see script 01 or outfiles of that job
#rset <- retcor.peakgroup(gset, plottype="none", ...)
#save(list=c("rset"), file=paste0(output_dir,"/02.2.2_RTcorrection.RData"))

## RT correction obiwarp
xdata <- adjustRtime(xset, param = ObiwarpParam(binSize = 0.4)) #somebody on the internet varied bin size between 0.2 and 2
write.csv(rtime(xdata), "./02.2.1_Samples_AdjustedTime.csv", row.names = TRUE)
save(list=c("xdata"), file=paste0(output_dir,"02.2.1_RTcorrection.Rdata"))

## Evaluate the RT alignment
## Get the base peak chromatograms.
bpis_adj <- chromatogram(xdata, aggregationFun = "max", include = "none")
par(mfrow = c(2, 1), mar = c(4.5, 4.2, 1, 0.5))
plot1<-plot(bpis_adj, col = group_colors[bpis_adj$sample_group])
## Plot also the difference of adjusted to raw retention time.
plot2 <- plotAdjustedRtime(xdata)

pdf("./02.2.1_Samples_RTcorrection_BPC.pdf") 
plot
dev.off()

pdf("./02.2.1_Samples_RTcorrection_AdjustedTimeDifference.pdf") 
plot
dev.off()

## Grouping No2
#grset <- group(rset, method="density", ...)
#save(list=c("grset"), file=paste0(output_dir,"/02.2.3_Grouping-2.RData"))

## Filling peaks
#fset <- fillPeaks(grset,
#                 method="chrom",
#                 BPPARAM = MulticoreParm(worker=bw))
#save(list=c("fset"), file=paste0(output_dir,"/02.2.4_FillingPeaks.RData"))

#Table=peakTable(fset)
#write.csv(Table, file=paste0(output_dir, "/02.2.5_Peak_Table_Name.csv"), col.names=FALSE)

