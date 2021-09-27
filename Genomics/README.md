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

Output are the html files containing the following stats:

| Feature | *T. adustus* | *T. bajacalifornicus* | *T. "raciborskii"* | 
| :------: | :------: |  :------: |  :------: |
| 
eature
General summary
Mean read length 6,083.5
Mean read quality 12.1
Median read length 2,699.0
Median read quality 12.4
Number of reads 4,843,950.0
Read length N50 12,769.0
Total bases 29,468,000,848.0
Number, percentage and megabases of reads above quality cutoffs
>Q5 4843950 (100.0%) 29468.0Mb
>Q7 4843950 (100.0%) 29468.0Mb
>Q10 3969870 (82.0%) 24405.3Mb
>Q12 2716358 (56.1%) 17425.9Mb
>Q15 332810 (6.9%) 1766.1Mb
Top 5 highest mean basecall quality scores and their read lengths
1 22.3 (505)
2 22.3 (505)
3 22.1 (225)
4 22.1 (225)
5 21.9 (234)
Top 5 longest reads and their mean basecall quality score
1 344457 (9.3)
2 344457 (9.3)
3 168487 (7.3)
4 168487 (7.3)
5 126122 (7.4)
