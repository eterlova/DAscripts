#!/bin/bash
#SBATCH --job-name=qc_raw
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
# FASTQC of raw reads 
#################################################################
# create an output directory to hold fastqc output
DIR="raw"
mkdir -p ${DIR}_fastqc

module load fastqc/0.11.7

for i in {1..36}
do fastqc --threads 4 --outdir ./${DIR}_fastqc/ /home/CAM/eterlova/2021DA_transcriptomes/data/LTervola_RNASeq_April2021/ET*_S$i*_R1_001.fastq.gz /home/CAM/eterlova/2021DA_transcriptomes/data/LTervola_RNASeq_April2021/ET*_S$i*_R2_001.fastq.gz 
done

#################################################################
# MULTIQC of raw reads 
#################################################################
module load MultiQC/1.9

mkdir -p ${DIR}_multiqc
multiqc --outdir ${DIR}_multiqc ./${DIR}_fastqc/
