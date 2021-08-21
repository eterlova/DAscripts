## This script performs 1) RT alignment on blank and experiment files
##                      2) Peack detection in blank and experiment 

#if (!requireNamespace("BiocManager", quietly=TRUE))
#  install.packages("BiocManager")
#BiocManager::install("IPO")
#install.packages("xcms", "RColorBrewer", "pander", "magrittr", "pheatmap", "SummarizedExperiment", "data.table")

library(xcms)
library(RColorBrewer)
library(pander)
library(magrittr)
library(pheatmap)
library(SummarizedExperiment)
#library(IPO)
library(data.table)

# 1.1 save path of each sample in a vector
#"sample_502" #does not exist
##samples <- c("sample_013", "sample_026")
#samples <- c("sample_013", "sample_026", "sample_056", "sample_063", "sample_110", "sample_111", "sample_127",
#             "sample_128", "sample_133", "sample_137", "sample_157", "sample_166", "sample_169", "sample_174",
#             "sample_176", "sample_190", "sample_193", "sample_216", "sample_217", "sample_224", "sample_245",
#             "sample_260", "sample_267", "sample_281", "sample_304", "sample_311", "sample_324", "sample_358",
#             "sample_360", "sample_361", "sample_366", "sample_375", "sample_387", "sample_389", "sample_400",
#             "sample_412", "sample_417", "sample_432", "sample_444", "sample_452", "sample_457", "sample_464",
#             "sample_469", "sample_485", "sample_518", "sample_532", "sample_577", "sample_582", "sample_583",
#             "sample_588", "sample_590", "sample_602", "sample_609", "sample_615")
  


#rawfiles <- vector()  

#for(i in samples){
#  add <- dir(path="~/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/Data", pattern=i, full.names = TRUE,
#             recursive = TRUE)
#  rawfiles[[length(rawfiles)+1]] <- add
#}
##rawfiles
##fwrite(list(rawfiles), file = "sample_paths.txt")

##pooled_files <- dir(path="~/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/Data", pattern="pulled", full.names = TRUE,
##              recursive = TRUE)
##fwrite(list(pooled), file = "pooled_paths.txt")

blanks_files <- dir(path="~/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/Data", pattern="MeOH",full.names = TRUE,
              recursive = TRUE)
##fwrite(list(blanks), file = "blanks_paths.txt")

# 1.2 read in phenotypes

##phenotypes <- read.table("~/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/ZA17_JT2_CCAP_alpha_phenotypes.csv",
##                       header=TRUE,
##                       sep=",")
##pooled_phenotypes <- read.table("~/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/pooled_phenotypes.csv",
##                    header=TRUE,
##                       sep=",")
blanks_phenotypes <- read.table("~/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/blanks_phenotypes.csv",
                    header=TRUE,
                       sep=",")

# 2. read the files

##raw_data <- readMSData(files = rawfiles, pdata = new("NAnnotatedDataFrame", phenotypes),
##                       mode = "onDisk")
##pooled <- readMSData(files = pooled_files, pdata = new("NAnnotatedDataFrame", pooled_phenotypes),
##                       mode = "onDisk")
blanks <- readMSData(files = blanks_files, pdata = new("NAnnotatedDataFrame", blanks_phenotypes),
                       mode = "onDisk")
#raw_data_test <- filterRt(raw_data, c(250, 350))

# 3. centroid data
# 3.1 smoothing data in the m/z dimention using Savitzky-Golay filter with a half-window size of 4
##raw_data_sg <- raw_data %>%
##    smooth(method = "SavitzkyGolay", halfWindowSize = 4L)
##pooled_sg <- pooled %>%
##    smooth(method = "SavitzkyGolay", halfWindowSize = 4L)
blanks_sg <- blanks %>%
    smooth(method = "SavitzkyGolay", halfWindowSize = 4L)

# 3.2. centroiding data using pickPeaks() with descendPeak m/z refinement
# descendPeak walks, on both sides from the centroid, down until the signal
#is below signalPercentage% of the centroid’s intensity (by default 33%), or until the signal increases again. 
#All m/z intensity pairs within this range are used for the weighted average calculation of the centroid’s m/z value.
##raw_data_cent <- raw_data_sg %>% pickPeaks(refineMz = "descendPeak")
##pooled_cent <- pooled_sg %>% pickPeaks(refineMz = "descendPeak")
blanks_cent <- blanks_sg %>% pickPeaks(refineMz = "descendPeak")
#

# 4. code from IPO outcome
#xset <- xcmsSet( 
#  method = "centWave",
#  peakwidth       = c(11.75, 32.9),
#  ppm             = 32,
#  noise           = 0,
#  snthresh        = 10,
#  mzdiff          = -0.001,
#  prefilter       = c(2, 200),
#  mzCenterFun     = "wMean",
#  integrate       = 1,
#  fitgauss        = FALSE,
#  verbose.columns = FALSE)
#xset <- retcor( 
#  xset,
#  method         = "obiwarp",
#  plottype       = "none",
#  distFunc       = "cor_opt",
#  profStep       = 1,
#  center         = 1,
#  response       = 1,
#  gapInit        = 0.2112,
#  gapExtend      = 2.7,
#  factorDiag     = 2,
#  factorGap      = 1,
#  localAlignment = 0)
#xset <- group( 
#  xset,
#  method  = "density",
#  bw      = 0.25,
#  mzwid   = 1e-04,
#  minfrac = 1,
#  minsamp = 1,
#  max     = 50)

#xset <- fillPeaks(xset)

# 4. chromatographic peak detection on extracted ion chromatogram (using pooled centWave parameters)
#chr_raw <- chromatogram(raw_data_cent)
chr_blank <- chromatogram(blanks_cent)
#xchr <- findChromPeaks(chr_raw, param = CentWaveParam(ppm = 32,
#                                                                 peakwidth = c(11.75, 32.9),
#                                                                 mzdiff = -0.001,
#                                                                 prefilter = c(2, 200),
#                                                                 snthresh = 10,
#                                                                 noise = 0,
#                                                                 mzCenterFun = "wMean",
#                                                                 integrate = 1,
#                                                                 fitgauss = FALSE,
#                                                                 extendLengthMSW = FALSE))

xchr_blank <- findChromPeaks(chr_raw, param = CentWaveParam(ppm = 32,
                                                                 peakwidth = c(11.75, 32.9),
                                                                 mzdiff = -0.001,
                                                                 prefilter = c(2, 200),
                                                                 snthresh = 10,
                                                                 noise = 0,
                                                                 mzCenterFun = "wMean",
                                                                 integrate = 1,
                                                                 fitgauss = FALSE,
                                                                 extendLengthMSW = FALSE))
head(chromPeaks(xchr_blank))
head(chromPeakData(xchr_blank))
write.csv(chromPeaks(xchr_blank), "~/2021DA_metabolomes/02_PeakDetection/Blanks_ChromPeaks.csv", row.names = TRUE)
write.csv(chromPeakData(xchr_blank),"~/2021DA_metabolomes/02_PeakDetection/Blanks_ChromPeakData.csv", row.names = TRUE)

pdf("Blanks_PeaksFromEIC.pdf") 
plot <- plot(xchr_blank)
dev.off() 

## 5. Peak detection on full data (as opposed to EIC)
xdata_blank <- findChromPeaks(blanks_cent, param = CentWaveParam(ppm = 32,
                                                                 peakwidth = c(11.75, 32.9),
                                                                 mzdiff = -0.001,
                                                                 prefilter = c(2, 200),
                                                                 snthresh = 10,
                                                                 noise = 1000, #note that this is different from IPO output, estimated from Blanks_PeaksFromEIC.pdf 
                                                                 mzCenterFun = "wMean",
                                                                 integrate = 1,
                                                                 fitgauss = FALSE,
                                                                 extendLengthMSW = FALSE))

## ChromPeaks(xdata_blank) is a matrix
#head(chromPeaks(xdata_blank))
#write.csv(chromPeaks(xdata_blank), "~/2021DA_metabolomes/02_PeakDetection/Blanks_Peaks_xdata", row.names=TRUE)
#write.csv(chromPeakData(xdata_blank), "~/2021DA_metabolomes/02_PeakDetection/Blanks_PeakData_xdata", row.names=TRUE)

## 5.1 Refinment of detected peaks
## post-process the peak detection results merging peaks overlapping in a 2 second window per file if the signal between in between them is lower than 75% of the smaller peak’s maximal intensity.
mpp <- MergeNeighboringPeaksParam(expandRt = 2)
xdata_blank_pp <- refineChromPeaks(xdata_blank, mpp)

write.csv(chromPeaks(xdata_blank_pp), "~/2021DA_metabolomes/02_PeakDetection/Blanks_Peaks_xdata_pp", row.names=TRUE)
write.csv(chromPeakData(xdata_blank_pp), "~/2021DA_metabolomes/02_PeakDetection/Blanks_PeakData_xdata_pp", row.names=TRUE)

pdf("Blanks_PeaksDetected.pdf") 
plot <- plot(xdata_blank)
dev.off() 

pdf("Blanks_PeaksDetected_and_merged.pdf") 
plot <- plot(xdata_blank_pp)
dev.off()

## 5.2. Summary statistics on identified chromatographic peaks. Shown are number of identified peaks per sample and widths/duration of chromatographic peaks.

summary_fun <- function(z)
    c(peak_count = nrow(z), rt = quantile(z[, "rtmax"] - z[, "rtmin"]))

T <- lapply(split.data.frame(
    chromPeaks(xdata_blank_pp), f = chromPeaks(xdata_blank_ppd)[, "sample"]), # incert the right data here
    FUN = summary_fun)
T <- do.call(rbind, T)
rownames(T) <- basename(fileNames(xdata_blank_pp))
pandoc.table(
    T,
    caption = paste0("Summary statistics on identified chromatographic",
                     " peaks. Shown are number of identified peaks per",
                     " sample and widths/duration of chromatographic ",
                     "peaks."))
write.csv(chromPeaks(T), "~/2021DA_metabolomes/02_PeakDetection/Summary_BlankPeaks_xdata_blank_pp", row.names=TRUE)


