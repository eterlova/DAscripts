#!/bin/bash
#SBATCH --job-name=Porechop_JT2
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=100G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

module load porechop

porechop -i /home/CAM/eterlova/2021DA_genomes/02_Centrifuge/JT2_abv_fungi_unclassified_reads_from_centrifuge.fastq -o JT2_trimmed.fastq -v 3 -t 40 
