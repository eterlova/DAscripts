#!/bin/bash
#SBATCH --job-name=CCAP_busco_shasta
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=5G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%A.out
#SBATCH -e %x_%A.err

hostname
date

##########################################################
##              BUSCO                                   ##      
##########################################################

module load busco/4.0.2

export AUGUSTUS_CONFIG_PATH=./augustus_config

busco -i /home/CAM/eterlova/2021DA_genomes/04_Assembly/Shasta/CCAP/Assembly.fasta \
        -o CCAP_busco_shasta_chlorophyta -l ./chlorophyta_odb10 -m genome
