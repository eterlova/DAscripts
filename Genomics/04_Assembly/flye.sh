#!/bin/bash
#SBATCH --job-name=CCAP_flye
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 32
#SBATCH --mem=600G
#SBATCH --partition=himem2
#SBATCH --qos=himem
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

module load flye/2.4.2

flye --nano-raw ../../03_Porechop/CCAP_trimmed.fasta \
        --genome-size 150m \
        --threads 32 \
        --iterations 3 \
        --out-dir /home/CAM/eterlova/2021DA_genomes/04_Assembly/Flye/CCAP_flye
