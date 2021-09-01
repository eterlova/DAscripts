## This script 1) loads files (XCMS package)
##             2) optimizes peak picking parameters (IPO package)
##             3) optimizes retention time aligning parameters (IPO package)
##             4) optimizes grouping parameters

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
library(IPO)
library(data.table)
#NB use normal slash (/) for file paths despite what Windows does

# 1.1 save path of each sample in a vector
#"sample_502" #does not exist
##samples <- c("sample_013", "sample_026")
##samples <- c("sample_013", "sample_026", "sample_056", "sample_063", "sample_110", "sample_111", "sample_127",
##             "sample_128", "sample_133", "sample_137", "sample_157", "sample_166", "sample_169", "sample_174",
##             "sample_176", "sample_190", "sample_193", "sample_216", "sample_217", "sample_224", "sample_245",
##             "sample_260", "sample_267", "sample_281", "sample_304", "sample_311", "sample_324", "sample_358",
##             "sample_360", "sample_361", "sample_366", "sample_375", "sample_387", "sample_389", "sample_400",
##             "sample_412", "sample_417", "sample_432", "sample_444", "sample_452", "sample_457", "sample_464",
##             "sample_469", "sample_485", "sample_518", "sample_532", "sample_577", "sample_582", "sample_583",
##             "sample_588", "sample_590", "sample_602", "sample_609", "sample_615")
  
##rawfiles <- vector()  

##for(i in samples){
##  add <- dir(path="~/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/Data", pattern=i, full.names = TRUE,
##             recursive = TRUE)
##  rawfiles[[length(rawfiles)+1]] <- add
##}
##rawfiles
##fwrite(list(rawfiles), file = "sample_paths.txt")

pooled_files <- dir(path="~/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/Data", pattern="pulled", full.names = TRUE,
              recursive = TRUE)
##fwrite(list(pooled), file = "pooled_paths.txt")

##blanks_files <- dir(path="~/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/Data", pattern="MeOH",full.names = TRUE,
##              recursive = TRUE)
##fwrite(list(blanks), file = "blanks_paths.txt")

# 1.2 read in phenotypes

##phenotypes <- read.table("/home/CAM/eterlova/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/ZA17_JT2_CCAP_alpha_phenotypes.csv",
##                       header=TRUE,
##                       sep=",")
pooled_phenotypes <- read.table("/home/CAM/eterlova/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/pooled_phenotypes.csv",
                    header=TRUE,
                       sep=",")
##blanks_phenotypes <- read.table("/home/CAM/eterlova/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/blanks_phenotypes.csv",
##                    header=TRUE,
##                       sep=",")

# 2. read the files

##raw_data <- readMSData(files = rawfiles, pdata = new("NAnnotatedDataFrame", phenotypes),
#                       mode = "onDisk")
pooled <- readMSData(files = pooled_files, pdata = new("NAnnotatedDataFrame", pooled_phenotypes),
                       mode = "onDisk")
##blanks <- readMSData(files = blanks_files, pdata = new("NAnnotatedDataFrame", blanks_phenotypes),
##                       mode = "onDisk")
#raw_data_test <- filterRt(raw_data, c(250, 350))

# 4 parameter optimization with IPO package
# QC samples should suffice for parameter optimization (polled samples?)

# 4.1 peak detection with matchedFilter parameter optimization
##peakpickingParameters_matchedFilter <- getDefaultXcmsSetStartingParams('matchedFilter')
#setting levels for step to 0.2 and 0.3 (hence 0.25 is the center point)
##peakpickingParameters_matchedFilter$step <- c(0.2, 0.3)
##peakpickingParameters_matchedFilter$fwhm <- c(40, 50)
#setting only one value for steps therefore this parameter is not optimized
##peakpickingParameters_matchedFilter$steps <- 2

##time.xcmsSet <- system.time({ # measuring time
##  resultPeakpicking_matchedFilter <- 
##    optimizeXcmsSet(files = pooled_files, 
##                    params = peakpickingParameters_matchedFilter, 
##                    nSlaves = 1, 
##                    subdir = NULL,
##                    plot = FALSE)
##})

#Best parameters:
#fwhm: 15
#snthresh: 6.22112
#step: 0.28848
#steps: 2
#sigma: 6.36996772549686
#max: 5
#mzdiff: 0.22304
#index: FALSE

# 4.2 centroiding data (required by CentWave algorithm)
# Biochanin m/z 285.0767 rt 5.30695
# Lidocaine m/z 235.1811 rt 3.15795

# 4.2.1 smoothing data in the m/z dimention using Savitzky-Golay filter with a half-window size of 4
#raw_data_sg <- raw_data %>%
#    smooth(method = "SavitzkyGolay", halfWindowSize = 4L)
pooled_sg <- pooled %>%
    smooth(method = "SavitzkyGolay", halfWindowSize = 4L)
##blanks_sg <- blanks %>%
##    smooth(method = "SavitzkyGolay", halfWindowSize = 4L)

# 4.2.2. centroiding data using pickPeaks() with descendPeak m/z refinement
# descendPeak walks, on both sides from the centroid, down until the signal
#is below signalPercentage% of the centroid’s intensity (by default 33%), or until the signal increases again. 
#All m/z intensity pairs within this range are used for the weighted average calculation of the centroid’s m/z value.
#raw_data_cent <- raw_data_sg %>% pickPeaks(refineMz = "descendPeak")
pooled_cent <- pooled_sg %>% pickPeaks(refineMz = "descendPeak")
##blanks_cent <- blanks_sg %>% pickPeaks(refineMz = "descendPeak")
#
print("Peak Picking parameter optimization with centWave based on pooled samples")
# 4.3 parameter optimization with centWave
peakpickingParameters_centWave <- getDefaultXcmsSetStartingParams('centWave')
peakpickingParameters_centWave$min_peakwidth <- c(5,14)
peakpickingParameters_centWave$max_peakwidth <- c(14,35)
peakpickingParameters_centWave$prefilter <- c(2,3)
peakpickingParameters_centWave$value_of_prefilter <- c(200,300)

# 4.3.1 based on pooled files
time.xcmsSet <- system.time({ # measuring time
  resultPeakpicking_centWave_pooled <- 
    optimizeXcmsSet(files = pooled_files,
                    params = peakpickingParameters_centWave, 
                    nSlaves = 10, 
                    subdir = NULL,
                    plot = FALSE)
}) 

# 4.3.2 based on blank files
##time.xcmsSet <- system.time({ # measuring time
##  resultPeakpicking_centWave_blanks <-
##    optimizeXcmsSet(files = blanks_files,
##                    params = peakpickingParameters_centWave,
##                    nSlaves = 1,
##                    subdir = NULL,
##                    plot = FALSE)
##})


print("Optimize retention time correction and grouping parameters based on pooled samples")
# 4.4 Optimize retention time correction and grouping parameters
retcorGroupParameters <- getDefaultRetGroupStartingParams()
retcorGroupParameters$profStep <- 1
retcorGroupParameters$gapExtend <- 2.7

time.RetGroup <- system.time({ # measuring time
resultRetcorGroup <-
  optimizeRetGroup(xset = resultPeakpicking_centWave_pooled$best_settings$xset, 
                   params = retcorGroupParameters, 
                   nSlaves = 10, 
                   subdir = NULL,
                   plot = FALSE)
})

print("A script which you can use to process your raw data")
writeRScript(resultPeakpicking_centWave_pooled$best_settings$parameters, 
             resultRetcorGroup$best_settings)
print("Above calculations proceeded with following running times")
print("time for optimizing peak picking parameters")
time.xcmsSet
print("time for optimizing retention time correction and grouping parameters")
time.RetGroup

## Best parameters
xset <- xcmsSet( 
  method = "centWave",
  peakwidth       = c(11.75, 32.9),
  ppm             = 32,
  noise           = 0,
  snthresh        = 10,
  mzdiff          = -0.001,
  prefilter       = c(2, 200),
  mzCenterFun     = "wMean",
  integrate       = 1,
  fitgauss        = FALSE,
  verbose.columns = FALSE)
xset <- retcor( 
  xset,
  method         = "obiwarp",
  plottype       = "none",
  distFunc       = "cor_opt",
  profStep       = 1,
  center         = 1,
  response       = 1,
  gapInit        = 0.2112,
  gapExtend      = 2.7,
  factorDiag     = 2,
  factorGap      = 1,
  localAlignment = 0)
xset <- group( 
  xset,
  method  = "density",
  bw      = 0.25,
  mzwid   = 1e-04,
  minfrac = 1,
  minsamp = 1,
  max     = 50)

xset <- fillPeaks(xset)
