#!/bin/bash
#SBATCH --job-name=02_PeakDetection
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=4G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --array=[0-50] ## put here how many files you have
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

dir="~/2021DA_metabolomes/02_PeakDetection_wconda"
file_list="~/2021DA_metabolomes/01_IPO_parameters_pooled/blanks_paths.txt"
out_dir="~/2021DA_metabolomes/02_PeakDetection_wconda"
#if [ ! -d "$out_dir" ]; then
#  mkdir "$out_dir"
#fi

cd "$dir"

conda activate Rmetab

Rscript --no-save --no-restore --verbose 02.1_PeakDetection.R \
"$file_list" "$SLURM_ARRAY_TASK_ID" "out_dir" \
> "~/2021DA_metabolomes/02_PeakDetection_wconda/outfile_$SLURM_JOB_ID.Rout" 2>&1 > $out_dir/$SLURM_JOB_ID.log
