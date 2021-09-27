## Comparing genome sequence of desert  and aquatic  algal species

## Introduction
*Tetradesmus bajacalifornicus* (ZA1-7) and *T. adustus* (JT2-VF29) are closely related desert species, *T. "raciborskii"* (CCAP 276/35) is an aquatic species sister to both of them.
<br>
### Directory Layout
The data used in this project can be accessed in the Xanadu cluster at the following directory: 'LLewis_lab'
<br>
To view the files use the following command:
<br>
<pre style="color: silver; background: black;">-bash-4.2$ ls LLewis_lab
data 01_QC 02_Centrifuge 03_Porechop 04_Assembly 05_AssemblyEvaluation 06_Error_correction 07_AssemblyEvaluation 08_Purge 09_Repeats 10_RepeatMasking 11_Evaluation_masked 12_RNAmapping 13_Minimap</pre> 

<br>
## 1. Quality Report
We use nanoplot a tool developed to evaluate the statistics of long read data of Oxford Nanopore Technologies and Pacific Biosciences. The summary of the data can be found here: [QC Analysis before processing](https://github.com/eterlova/DAscripts/tree/main/Genomics/01_QC/Nanoplot_beforeProcessing.pdf)


<pre style="color: silver; background: black;">
#!/bin/bash
#SBATCH --job-name=nanoplot_JT2
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

NanoPlot --fastq /home/CAM/eterlova/2021DA_genomes/data/JT2_all.fastq \
        --loglength \
        -o JT2all_new-summary-plots-log-transformed \
        -t 10

date
module list</pre>

Main metrics from Nanoplot:

| Feature | *T. adustus* JT2-VF29 | *T. bajacalifornicus* ZA 1-7| *T. "raciborskii"* CCAP| 
| :------: | :------: |  :------: |  :------: |
| Mean read length | 6,083.5 |  9,954.0 |  :------: |
| Mean read quality | 12.1 |  11.9 |  :------: |
| Median read length | 2,699.0 |  7,900.0 |  :------: |
| Median read quality | 12.4 |  12.2 |  :------: |
| Number of reads | 4,843,950.0 |  1,746,873.0 |  :------: |
| Read length N50 | 12,769.0 |  17,894.0 |  :------: |
| Total bases | 29,468,000,848.0 |  17,388,312,276.0 |  :------: |
