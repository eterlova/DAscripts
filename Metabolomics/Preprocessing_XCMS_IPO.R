#if (!requireNamespace("BiocManager", quietly=TRUE))
#  install.packages("BiocManager")
#BiocManager::install("IPO")
#install.packages("xcms", "RColorBrewer", "pander", "magrittr", "pheatmap", "SummarizedExperiment")

library(xcms)
library(RColorBrewer)
library(pander)
library(magrittr)
library(pheatmap)
library(SummarizedExperiment)
library(IPO)
#NB use normal slash (/) for file paths despite what Windows does

# 1.1 save path of each sample in a vector
#"sample_502" #does not exist
samples <- c("sample_013", "sample_026")
#samples <- c("sample_013", "sample_026", "sample_056", "sample_063", "sample_110", "sample_111", "sample_127",
             "sample_128", "sample_133", "sample_137", "sample_157", "sample_166", "sample_169", "sample_174",
             "sample_176", "sample_190", "sample_193", "sample_216", "sample_217", "sample_224", "sample_245",
             "sample_260", "sample_267", "sample_281", "sample_304", "sample_311", "sample_324", "sample_358",
             "sample_360", "sample_361", "sample_366", "sample_375", "sample_387", "sample_389", "sample_400",
             "sample_412", "sample_417", "sample_432", "sample_444", "sample_452", "sample_457", "sample_464",
             "sample_469", "sample_485", "sample_518", "sample_532", "sample_577", "sample_582",
             "sample_583", "sample_588", "sample_590", "sample_602", "sample_609", "sample_615")
  
rawfiles <- vector()  

for(i in samples){
  add <- dir(path="D:/DA_metabolomics_mzML", pattern=i, full.names = TRUE,
             recursive = TRUE)
  rawfiles[[length(rawfiles)+1]] <- add
}


#rawfiles

# 1.2 read in phenotypes

phenotypes <- read.table("C:/Users/LisaTerlova/Documents/DAmetabolomics/ZA17_JT2_CCAP_alpha/ZA17_JT2_CCAP_alpha_phenotypes.csv",
                       header=TRUE,
                       sep=",")

# 2. read the files

raw_data <- readMSData(files = rawfiles, pdata = new("NAnnotatedDataFrame", phenotypes),
                       mode = "onDisk")
raw_data_test <- filterRt(raw_data, c(250, 350))

# 3. initial data inspection
#group_colors <- paste0(brewer.pal(3, "Set1"), "60")
#names(group_colors) <- c("ZA1-7", "CCAP 276/35", "JT2-VF29")

# Get the base peak chromatograms
#bpis <- chromatogram(raw_data_test, aggregationFun="max")# base peak chromatograms (BPC)
#plot(bpis, col = group_colors[raw_data_test$Strain])

# Get the total ion current by file
#tc <- split(tic(raw_data_test), f = fromFile(raw_data_test))
#boxplot(tc, col = group_colors[raw_data_test$Strain],
#        ylab = "intensity", main = "Total ion current")

# 4. chromatographic peak detection
# 4.1 parameter optimization with IPO package)
# QC samples should suffice for parameter optimization (polled samples?)

# peak detection with matchedFilter
#peakpickingParameters_matchedFilter <- getDefaultXcmsSetStartingParams('matchedFilter')
#setting levels for step to 0.2 and 0.3 (hence 0.25 is the center point)
#peakpickingParameters$step <- c(0.2, 0.3)
#peakpickingParameters$fwhm <- c(40, 50)
#setting only one value for steps therefore this parameter is not optimized
#peakpickingParameters$steps <- 2

#time.xcmsSet <- system.time({ # measuring time
#  resultPeakpicking_matchedFilter <- 
#    optimizeXcmsSet(files = rawfiles, #insert list of polled files instead
#                    params = peakpickingParameters, 
#                    nSlaves = 1, 
#                    subdir = NULL,
#                    plot = TRUE)
#})

#best parameter settings: also saved in resultPeakpicking
#fwhm: 9.3
#snthresh: 1
#step: 0.2884
#steps: 2
#sigma: 3.94937998980805
#max: 5
#mzdiff: 0.2232
#index: FALSE

# peak detection with centWave
peakpickingParameters_centWave <- getDefaultXcmsSetStartingParams('centWave')
peakpickingParameters_centWave$min_peakwidth <- c(5,14)
peakpickingParameters_centWave$max_peakwidth <- c(14,35)
peakpickingParameters_centWave$prefilter <- c(2,3)
peakpickingParameters_centWave$value_of_prefilter <- c(200,300)

time.xcmsSet <- system.time({ # measuring time
  resultPeakpicking_centWave <- 
    optimizeXcmsSet(files = rawfiles, #insert list of polled files instead
                    params = peakpickingParameters_centWave, 
                    nSlaves = 1, 
                    subdir = NULL,
                    plot = FALSE)
})

# the same with fitgauss=TRUE
time.xcmsSet <- system.time({ # measuring time
  resultPeakpicking_centWave <- 
    optimizeXcmsSet(files = rawfiles, #insert list of polled files instead
                    params = peakpickingParameters_centWave, 
                    nSlaves = 1, 
                    subdir = NULL,
                    plot = FALSE,
                    fitgauss=TRUE)
})
