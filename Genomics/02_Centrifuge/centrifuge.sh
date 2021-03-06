#!/bin/bash
#SBATCH --job-name=centrifuge_CCAP
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 18
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=40G
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

module load centrifuge/1.0.4-beta

workingdir=/home/CAM/eterlova/2021DA_genomes/
indexdir=/projects/EBP/Wegrzyn/Moss/ppyriforme/initial_analysis/centrifuge_14813/centrifuge_analysis/1_index/

centrifuge --un $workingdir/02_Centrifuge/CCAP_abv_fungi_unclassified_reads_from_centrifuge.fastq\
 --mm\
 --min-hitlen 30\
 --report-file $workingdir/02_Centrifuge/CCAP_centrifuge_abvf_30.tsv\
 -p 12\
 -x $indexdir/abv/index/abv\
 -x $indexdir/fungi/fungi\
 -U $workingdir/data/CCAP_all.fastq # path to the raw reads here
