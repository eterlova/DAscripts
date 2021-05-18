#!/bin/bash
#SBATCH --job-name=nanoplot_ZAporechop
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 10
#SBATCH --mem=50G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

echo "HOSTNAME: `hostname`"
echo "Start Time: `date`"

module load


module load NanoPlot/1.21.0

NanoPlot --fasta /home/CAM/eterlova/2021DA_genomes/03_Porechop/ZA17_trimmed.fasta \ #path to raw or trimmed data
        --loglength \
        -o ZA17-porechop-summary-plots-log-transformed \
        -t 10

date
module list
