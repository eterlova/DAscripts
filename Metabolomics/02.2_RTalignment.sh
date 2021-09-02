#!/bin/bash
#SBATCH --job-name=PeakDetection-2
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=16G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --array=[0-52] ## put here how many files you have
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err

input_dir="~/2021DA_metabolomes/02_PeakDetection_wconda"
output_dir="$input_dir"

source ~/miniconda3/etc/profile.d/conda.sh
conda activate Rmetab

Rscript --no-save --no-restore --verbose 02.2_PeakDetection.R \
"input_dir" "out_dir" "$SLURM_ARRAY_TASK_ID" \
> "outfile_RTalignment_"$SLURM_JOB_ID".Rout" 2>&1 > "$SLURM_JOB_ID".log

cat *.log > RTalignment.log 
rm "$SLURM_JOB_ID".log
