#!/bin/bash
#SBATCH --job-name=qc_trimmed
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=10G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

echo `hostname`

#################################################################
# FASTQC of trimmed reads 
#################################################################
# create an output directory to hold fastqc output
DIR="trimmed"
mkdir -p ${DIR}_fastqc

module load fastqc/0.11.7

for i in {1..36}
do fastqc --threads 4 --outdir ./${DIR}_fastqc/ ./trim*$i*_R1.fastq.gz ./trim*$i*_R2.fastq.gz 
done

#################################################################
# MULTIQC of trimmed reads 
#################################################################
module load MultiQC/1.9

mkdir -p ${DIR}_multiqc
multiqc --outdir ${DIR}_multiqc ./${DIR}_fastqc/
