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

| Feature | *T. adustus* | *T. bajacalifornicus* | *T. "raciborskii"* | 
| :------: | :------: |  :------: |  :------: |
|  | **JT2-VF29** |  **ZA 1-7** |  **CCAP 276/35** |
| Mean read length | 6,083.5 |  9,954.0 |  :------: |
| Mean read quality | 12.1 |  11.9 |  :------: |
| Median read length | 2,699.0 |  7,900.0 |  :------: |
| Median read quality | 12.4 |  12.2 |  :------: |
| Number of reads | 4,843,950.0 |  1,746,873.0 |  :------: |
| Read length N50 | 12,769.0 |  17,894.0 |  :------: |
| Total bases | 29,468,000,848.0 |  17,388,312,276.0 |  :------: |

Coverage estimates (Our goal is 40x):

|  | *T. adustus* | *T. bajacalifornicus* | *T. "raciborskii"* | 
| :------: | :------: |  :------: |  :------: |
|  | **JT2-VF29** |  **ZA 1-7** |  **CCAP 276/35** |
| Total bases | 29,468,000,848.0 |  17,388,312,276.0 |  :------: |
| Genome size | 1,5e+8 |  1,5e+8 |  1,5e+8 |
| Initial coverage | 196.4X |  115.9X |  :------: |

### Contaminant Screening
To filter out bacterial and fungal contaminants we ran Centrifuge. We ran centrifuge two times with varying hit lengths (30 and 50 bp). Here is the script we used 'centrifuge.sh':

<pre style="color: silver; background: black;">
#!/bin/bash
#SBATCH --job-name=centrifuge
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 18
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --array=[0-2]
#SBATCH --mail-type=END
#SBATCH --mem=40G
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

data

module load centrifuge/1.0.4-beta

workingdir=~/2021DA_genomes
indexdir=/projects/EBP/Wegrzyn/Moss/ppyriforme/initial_analysis/centrifuge_14813/centrifuge_analysis/1_index/

LIST=($(echo JT2 ZA17 CCAP))
SAM=${LIST[$SLURM_ARRAY_TASK_ID]}

centrifuge --un $workingdir/02_Centrifuge/${SAM}_50_abv_fungi_unclassified_reads_from_centrifuge\
 --mm\
 --min-hitlen 50\
 --report-file $workingdir/02_Centrifuge/${SAM}_50_abv_fungi_unclassified_reads_from_centrifuge/${SAM}_centrifuge_abvf_50.tsv\
 -p 12\
 -x $indexdir/abv/index/abv\
 -x $indexdir/fungi/fungi\
 -U $workingdir/02_Centrifuge/${SAM}_all.fastq
 data</pre>
 
Centrifuge results (evaluated with Nanoplot):

<table>
  <tr>
    <td></td>
    <td colspan="2"><i>T. adustus</i></td>
    <td colspan="2"><i>T. bajacalifornicus</i></td>
    <td colspan="2"><i>T. "raciborskii"</i></td>
  </tr>
  <tr>
    <td></td>
    <td colspan="2"><b> JT2-VF29</b></td>
    <td colspan="2"> <b> ZA 1-7 </b></td>
    <td colspan="2"><b> CCAP 276/35</b></td>
  </tr>
  <tr>
    <td> </td>
    <td> 30 bp </td>
    <td> 50 bp</td>
    <td> 30 bp </td>
    <td> 50 pb </td>
    <td> 30 bp </td>
    <td> 50 bp </td>     
  </tr>
  <tr>
    <td>Mean read length</td>
    <td>4,667.3</td>
    <td></td>
    <td>5,634.7</td>
    <td></td>
    <td>1,229.9</td>
    <td></td>
  </tr>
   <tr>
    <td>Mean read quality</td>
    <td>12.1</td>
    <td></td>
    <td>11.9</td>
    <td></td>
    <td>12.2</td>
    <td></td>
  </tr>
   <tr>
    <td>Median read length</td>
    <td>1,382.0</td>
    <td></td>
    <td>1,760.0</td>
    <td></td>
    <td>551.0</td>
    <td></td>
  </tr>
   <tr>
    <td>Median read quality</td>
    <td>12.3</td>
    <td></td>
    <td>12.1</td>
    <td></td>
    <td>12.3</td>
    <td></td>
  </tr>
   <tr>
    <td>Number of reads</td>
    <td>3,932,242.0</td>
    <td></td>
    <td>1,027,612.0</td>
    <td></td>
    <td>9,597,728.0</td>
    <td></td>
  </tr>
   <tr>
    <td>Read length N50</td>
    <td>11,583.0</td>
    <td></td>
    <td>13,790.0</td>
    <td></td>
    <td>2,339.0</td>
    <td></td>
  </tr>
   <tr>
    <td>Total bases</td>
    <td>18,352,972,188.0</td>
    <td></td>
    <td>5,790,296,574.0</td>
    <td></td>
    <td>11,804,110,380.0</td>
    <td></td>
  </tr>
  <tr>
    <td>Genome coverage </td>
    <td>122.3X</td>
    <td></td>
    <td>38.6X</td>
    <td></td>
    <td>78.7X</td>
    <td></td>
  </tr>
</table>

### Removing adapters
To remove adapters, I ran Porechop on unclassified Centrifuge reads using the following 'porechop.sh' script:
<pre style="color: silver; background: black;">
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

porechop -i /home/CAM/eterlova/2021DA_genomes/02_Centrifuge/JT2_abv_fungi_unclassified_reads_from_centrifuge.fastq \
         -o JT2_trimmed.fastq \
         -v 3 \
         -t 40</pre>

Command options:
<pre style="color: silver; background: black;">porechop -i INPUT 
[-o OUTPUT]
[--format {auto,fasta,fastq,fasta.gz,fastq.gz}] [-v VERBOSITY]
               [-t THREADS] </pre>

<br>
## 2. Assembly
In this step we uses three asseblers Canu, Flye, and Shasta on the filtered and trimmed reads

<br>
## 2. Assembly
In this step we uses three asseblers Canu, Flye, and Shasta on the filtered and trimmed reads
