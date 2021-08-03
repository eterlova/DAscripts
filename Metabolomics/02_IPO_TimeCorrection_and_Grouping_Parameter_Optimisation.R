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

# 1.1 save path of each sample in a vector
#"sample_502" #does not exist
##samples <- c("sample_013", "sample_026")
samples <- c("sample_013", "sample_026", "sample_056", "sample_063", "sample_110", "sample_111", "sample_127",
             "sample_128", "sample_133", "sample_137", "sample_157", "sample_166", "sample_169", "sample_174",
             "sample_176", "sample_190", "sample_193", "sample_216", "sample_217", "sample_224", "sample_245",
             "sample_260", "sample_267", "sample_281", "sample_304", "sample_311", "sample_324", "sample_358",
             "sample_360", "sample_361", "sample_366", "sample_375", "sample_387", "sample_389", "sample_400",
             "sample_412", "sample_417", "sample_432", "sample_444", "sample_452", "sample_457", "sample_464",
             "sample_469", "sample_485", "sample_518", "sample_532", "sample_577", "sample_582", "sample_583",
             "sample_588", "sample_590", "sample_602", "sample_609", "sample_615")
  


rawfiles <- vector()  

for(i in samples){
  add <- dir(path="~/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/Data", pattern=i, full.names = TRUE,
             recursive = TRUE)
  rawfiles[[length(rawfiles)+1]] <- add
}
##rawfiles
##fwrite(list(rawfiles), file = "sample_paths.txt")

pooled_files <- dir(path="~/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/Data", pattern="pulled", full.names = TRUE,
              recursive = TRUE)
##fwrite(list(pooled), file = "pooled_paths.txt")

blanks_files <- dir(path="~/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/Data", pattern="MeOH",full.names = TRUE,
              recursive = TRUE)
##fwrite(list(blanks), file = "blanks_paths.txt")

# 1.2 read in phenotypes

phenotypes <- read.table("/home/CAM/eterlova/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/ZA17_JT2_CCAP_alpha_phenotypes.csv",
                       header=TRUE,
                       sep=",")
pooled_phenotypes <- read.table("/home/CAM/eterlova/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/pooled_phenotypes.csv",
                    header=TRUE,
                       sep=",")
blanks_phenotypes <- read.table("/home/CAM/eterlova/2021DA_metabolomes/ZA17_JT2_CCAP_alpha_data/blanks_phenotypes.csv",
                    header=TRUE,
                       sep=",")

# 2. read the files

raw_data <- readMSData(files = rawfiles, pdata = new("NAnnotatedDataFrame", phenotypes),
                       mode = "onDisk")
pooled <- readMSData(files = pooled_files, pdata = new("NAnnotatedDataFrame", pooled_phenotypes),
                       mode = "onDisk")
blanks <- readMSData(files = blanks_files, pdata = new("NAnnotatedDataFrame", blanks_phenotypes),
                       mode = "onDisk")
#raw_data_test <- filterRt(raw_data, c(250, 350))

# 5 chromatographic peak detection (using pooled centWave parameters)
xchr <- findChromPeaks(raw_data_test_cent, param = CentWaveParam(ppm = 32,
                                                                 peakwidth = c(11.75, 32.9),
                                                                 mzdiff = -0.001,
                                                                 prefilter = c(2, 200),
                                                                 snthresh = 10,
                                                                 noise = 0,
                                                                 mzCenterFun = "wMean",
                                                                 integrate = 1,
                                                                 fitgauss = FALSE,
                                                                 extendLengthMSW = FALSE))




