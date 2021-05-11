#!/bin/bash
#SBATCH --job-name=Trimmomatic
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=100G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

module load Trimmomatic/0.39

for i in {1..36}
do java -jar $Trimmomatic PE -threads 4 \
        /home/CAM/eterlova/2021DA_transcriptomes/data/LTervola_RNASeq_April2021/ET*_S$"i"*_R1_001.fastq.gz \
        /home/CAM/eterlova/2021DA_transcriptomes/data/LTervola_RNASeq_April2021/ET*_S$"i"*_R2_001.fastq.gz \
        trim_S$"i"_R1.fastq.gz singles_trim_S"$i"_R1.fastq.gz \
        trim_S$"i"_R2.fastq.gz singles_trim_S"$i"_R2.fastq.gz \
        ILLUMINACLIP:/isg/shared/apps/Trimmomatic/0.36/adapters/NexteraPE-PE.fa \
        SLIDINGWINDOW:4:28 MINLEN:42 LEADING:28 TRAILING:28
done
