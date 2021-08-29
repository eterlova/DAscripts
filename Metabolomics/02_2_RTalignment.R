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
save
