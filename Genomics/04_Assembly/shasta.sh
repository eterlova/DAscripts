#!/bin/bash
#SBATCH --job-name=CCAP_shasta
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 32
#SBATCH --mem=500G
#SBATCH --partition=himem2
#SBATCH --qos=himem
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%A.out
#SBATCH -e %x_%A.err

hostname
date

##########################################################
##              shasta Assembly                         ##
##########################################################

module load shasta/0.5.1

shasta --input ../../03_Porechop/CCAP_trimmed.fasta \
        --Reads.minReadLength 1000 \
        --memoryMode anonymous \
        --threads 32 # \
#       --assemblyDirectory /home/CAM/eterlova/2021DA_genomes/04_Assembly/Shasta/CCAP
date
