## This script performs PEak-picking of individual data files in independent R sessions (PeakDetection1.sh)
args = commandArgs(trailingOnly=TRUE)
library(xcms)
library(SummarizedExperiment)

## File list
file_list <- paste0(args[1])
files <- read.table(file=file_list, stringsAsFactors=FALSE, header=F, sep="")

## Data file to process
f <- as.numeric(paste0(args[2]))
file <- files[f,1]

## Output dir
output_dir <- paste0(args[3])

## Read in data
rawdata <- readMSData(file, mode = "onDisk")

## Centroid data
## smoothing data in the m/z dimention using Savitzky-Golay filter with a half-window size of 4
rawdata_sg <- f %>%
    smooth(method = "SavitzkyGolay", halfWindowSize = 4L)
#pooled_sg <- pooled %>%
#    smooth(method = "SavitzkyGolay", halfWindowSize = 4L)
#blanks_sg <- blanks %>%
#    smooth(method = "SavitzkyGolay", halfWindowSize = 4L)

## centroiding data using pickPeaks() with descendPeak m/z refinement
## descendPeak walks, on both sides from the centroid, down until the signal
##is below signalPercentage% of the centroid’s intensity (by default 33%), or until the signal increases again. 
#All m/z intensity pairs within this range are used for the weighted average calculation of the centroid’s m/z value.
rawdata_cent <- rawdata_sg %>% pickPeaks(refineMz = "descendPeak")
#pooled_cent <- pooled_sg %>% pickPeaks(refineMz = "descendPeak")
#blanks_cent <- blanks_sg %>% pickPeaks(refineMz = "descendPeak")
#

## Peak detection on full data (as opposed to EIC)
xdata <- findChromPeaks(rawdata_cent, param = CentWaveParam(ppm = 32,
                                                                 peakwidth = c(11.75, 32.9),
                                                                 mzdiff = -0.001,
                                                                 prefilter = c(2, 200),
                                                                 snthresh = 10,
                                                                 noise = 1000, #note that this is different from IPO output, estimated from Blanks_PeaksFromEIC.pdf 
                                                                 mzCenterFun = "wMean",
                                                                 integrate = 1,
                                                                 fitgauss = FALSE,
                                                                 extendLengthMSW = FALSE))

##Refinment of detected peaks
## post-process the peak detection results merging peaks overlapping in a 2 second window per file if the signal between in between them is lower than 75% of the smaller peak’s maximal intensity.
mpp <- MergeNeighboringPeaksParam(expandRt = 2)
xdata_pp <- refineChromPeaks(xdata, mpp)

write.csv(chromPeaks(xdata_pp), "~/2021DA_metabolomes/02_PeakDetection_wconda/Samples_Peaks_xdata_pp", row.names=TRUE)
write.csv(chromPeakData(xdata_pp), "~/2021DA_metabolomes/02_PeakDetection_wconda/Samples_PeakData_xdata_pp", row.names=TRUE)
saveRDS(xdata, file=paste0(output_dir, "/02.1_PeakDetection", f, ".rds"))

pdf("Samples_PeaksDetected.pdf") 
plot <- plot(xdata_blank)
dev.off() 

pdf("Samples_PeaksDetected_and_merged.pdf") 
plot <- plot(xdata_blank_pp)
dev.off()
