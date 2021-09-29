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

## 2. Assembly
In this step we uses three asseblers Canu, Flye, and Shasta on the filtered and trimmed reads.

### Shasta assembly
The most rapid assembler. The script, which we used 'shasta.sh':
<pre style="color: silver; background: black;">
#!/bin/bash
#SBATCH --job-name=JT2_shasta
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 32
#SBATCH --mem=500G
#SBATCH --partition=himem2
#SBATCH --array=[0-2]
#SBATCH --qos=himem
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%A.out
#SBATCH -e %x_%A.err

hostname
date

LIST=($(echo JT2 ZA17 CCAP))
SAM=${LIST[$SLURM_ARRAY_TASK_ID]}

##########################################################
##              shasta Assembly                         ##
##########################################################

module load shasta/0.5.1

shasta --input ../../03_Porechop/${SAM}_trimmed.fasta \
        --Reads.minReadLength 1000 \
        --memoryMode anonymous \
        --threads 32  \
        --assemblyDirectory /home/CAM/eterlova/2021DA_genomes/04_Assembly/Shasta/${SAM}
date</pre>

Assembly is saved in a file Assembly.fasta

### Flye assembly and polish
We usee flye assembly with 6 polishing iterations (number of iteration was chosen from several options using Busco scores). The script 'flye.sh':
<pre style="color: silver; background: black;">
#!/bin/bash
#SBATCH --job-name=JT2_flye6
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 32
#SBATCH --mem=600G
#SBATCH --partition=himem2
#SBATCH --qos=himem
#SBATCH --array=[0-2]
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

LIST=($(echo JT2 ZA17 CCAP))
SAM=${LIST[$SLURM_ARRAY_TASK_ID]}

module load flye/2.4.2

flye --nano-raw ../../03_Porechop/${SAM}_trimmed.fasta \
        --genome-size 150m \
        --threads 32 \
        --iterations 6 \
        --out-dir /home/CAM/eterlova/2021DA_genomes/04_Assembly/Flye/${SAM}_flye_polish6
</pre>

Assembly is saved in a file assembly.fasta

### Canu assembly
Canu takes much longer to finish than the other two assemblers. Note: the email signaling the finish of a job comes much earlier than the job is actually over. Monitor the active jobs on the cluster using the command <pre style="color: silver; background: black;">squeue job# </pre>
The script used for Canu assembly:
<pre style="color: silver; background: black;">
#!/bin/bash
#SBATCH --job-name=JT2_canu
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 24
#SBATCH --mem=600G
#SBATCH --partition=himem2
#SBATCH --qos=himem
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

module load gnuplot/5.2.2
module load canu/2.1.1

canu useGrid=true \
        -p JT2 -d JT2 \
        genomeSize=150M \
        -nanopore ../../03_Porechop/JT2_trimmed.fasta gridOptions="--partition=himem2 --qos=himem  --mem-per-cpu=24G --cpus-per-task=24"</pre>
Assembly is saved as contigs.fasta file

## 3. Assembly Evaluation
We evaluated initial assemblies with Busco and QUAST

### Busco
To run Busco it is necessary to copy the augustus config directory and an appropriate busco library to an accessible location.
<pre style="color: silver; background: black;">
#!/bin/bash
#SBATCH --job-name=JT2_busco_flye
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

busco -i /home/CAM/eterlova/2021DA_genomes/04_Assembly/Flye/JT2_flye_polish6/assembly.fasta \
        -o JT2_busco_flye6_chlorophyta -l ./chlorophyta_odb10 -m genome</pre>
        
BUSCO results for the initial assembly:
<table>
  <tr>
    <td></td>
    <td colspan="3"><i>T. adustus</i> (JT2-VF29)</td>
    <td colspan="3"><i>T. bajacalifornicus</i> (ZA 1-7)</td>
    <td colspan="3"><i>T. "raciborskii"</i> (CCAP 276/35)</td>
  </tr>
  <tr>
    <td></td>
    <td>Shasta</td>
    <td>Flye + 6 polish</td>
    <td>Canu</td>
    <td>Shasta</td>
    <td>Flye + 6 polish</td>
    <td>Canu</td>
    <td>Shasta</td>
    <td>Flye + 6 polish</td>
    <td>Canu</td>
  </tr>
  <tr>
    <td>Complete BUSCOs</td>
    <td>73.8%</td>
    <td>74%</td>
    <td>78.9%</td>
    <td>50.9%</td>
    <td>65.1%</td>
    <td>67.7%</td>
    <td>44.9%</td>
    <td>66.0%</td>
    <td>68.1%</td>    
  </tr>
  <tr>
    <td>Complete and single-copy</td>
    <td>71.4%</td>
    <td>70.2%</td>
    <td>74.0%</td>
    <td>40.2%</td>
    <td>59.2%</td>
    <td>45.2%</td>
    <td>40.5%</td>
    <td>60.6%</td>
    <td>62.1%</td>  
  </tr>
   <tr>
    <td>Complete and duplicated</td>
    <td>2.4%</td>
    <td>3.8%</td>
    <td>4.9%</td>
    <td>10.7%</td>
    <td>5.9%</td>
    <td>22.5%</td>
    <td>4.4%</td>
    <td>5.4%</td>
    <td>6.0%</td> 
  </tr>
   <tr>
    <td>Fragmented BUSCOs</td>
    <td>1.7%</td>
    <td>2.3%</td>
    <td>2.0%</td>
    <td>2.2%</td>
    <td>2.0%</td>
    <td>2.6%</td>
    <td>2.9%</td>
    <td>1.8%</td>
    <td>2.9%</td>
  </tr>
   <tr>
    <td>Missong BUSCOs</td>
    <td>24.5%</td>
    <td>23.7%</td>
    <td>19.1%</td>
    <td>46.9%</td>
    <td>32.9%</td>
    <td>29.7%</td>
    <td>52.2%</td>
    <td>32.2%</td>
    <td>29.0%</td>
  </tr>
   <tr>
    <td>Total groups searched</td>
    <td colspan="9">1519</td>
  </tr>
</table>

### QUAST
This method of assembly evaluation gives you values on length-related metrics. The script to use Quast on Flye assembly:
<pre style="color: silver; background: black;">
#!/bin/bash
#SBATCH --job-name=JT2_quast_flye_polish
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 16
#SBATCH --mem=10G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%A.out
#SBATCH -e %x_%A.err

hostname
date

##########################################################
##              QUAST                                   ##      
##########################################################

module load quast/5.0.2

quast.py /home/CAM/eterlova/2021DA_genomes/04_Assembly/Flye/JT2_flye_polish6/assembly.fasta \
        --threads 16 \
        -o JT2_quast_flye_polish6</pre>
QUAST results on initial assemlies:
<table>
  <tr>
    <td></td>
    <td colspan="3"><i>T. adustus</i> (JT2-VF29)</td>
    <td colspan="3"><i>T. bajacalifornicus</i> (ZA 1-7)</td>
    <td colspan="3"><i>T. "raciborskii"</i> (CCAP 276/35)</td>
  </tr>
  <tr>
    <td></td>
    <td>Shasta</td>
    <td>Flye + 6 polish</td>
    <td>Canu</td>
    <td>Shasta</td>
    <td>Flye + 6 polish</td>
    <td>Canu</td>
    <td>Shasta</td>
    <td>Flye + 6 polish</td>
    <td>Canu</td>
  </tr>
  <tr>
    <td># contigs (>= 0 bp)</td>
    <td>2300</td>
    <td>890</td>
    <td>1980</td>
    <td>5211</td>
    <td>1402</td>
    <td>3604</td>
    <td>3161</td>
    <td>1881</td>
    <td>4672</td>    
  </tr>
  <tr>
    <td># contigs (>= 1000 bp)</td>
    <td>1836</td>
    <td>877</td>
    <td>1980</td>
    <td>3654</td>
    <td>1317</td>
    <td>3604</td>
    <td>2468</td>
    <td>1834</td>
    <td>4672</td>  
  </tr>
   <tr>
    <td># contigs (>= 5000 bp)</td>
    <td>1640</td>
    <td>856</td>
    <td>1924</td>
    <td>2892</td>
    <td>1238</td>
    <td>3463</td>
    <td>1958</td>
    <td>1683</td>
    <td>3415</td> 
  </tr>
   <tr>
    <td># contigs (>= 10000 bp)</td>
    <td>1445</td>
    <td>838</td>
    <td>1759</td>
    <td>2295</td>
    <td>1191</td>
    <td>3115</td>
    <td>1560</td>
    <td>1531</td>
    <td>2552</td>
  </tr>
  <tr>
    <td># contigs (>= 25000 bp)</td>
    <td>965</td>
    <td>750</td>
    <td>1153</td>
    <td>1018</td>
    <td>1033</td>
    <td>1796</td>
    <td>702</td>
    <td>1045</td>
    <td>1202</td>
  </tr>
  <tr>
    <td># contigs (>= 50000 bp)</td>
    <td>528</td>
    <td>565</td>
    <td>606</td>
    <td>325</td>
    <td>629</td>
    <td>628</td>
    <td>228</td>
    <td>503</td>
    <td>365</td>
  </tr>
  <tr>
    <td>Total length (>= 0 bp)</td>
    <td>89518716</td>
    <td>89993021</td>
    <td>107451818</td>
    <td>85647687</td>
    <td>89621955</td>
    <td>130781131</td>
    <td>68613698</td>
    <td>88960490</td>
    <td>110886168</td>
  </tr>
  <tr>
    <td>Total length (>= 1000 bp)</td>
    <td>89436720</td>
    <td>89984635</td>
    <td>107451818</td>
    <td>85297300</td>
    <td>89564644</td>
    <td>130781131</td>
    <td>68427280</td>
    <td>88928315</td>
    <td>110886168</td>
  </tr>
  <tr>
    <td>Total length (>= 5000 bp)</td>
    <td>88908256</td>
    <td>89930506</td>
    <td>107273257</td>
    <td>83305064</td>
    <td>89335505</td>
    <td>130304813</td>
    <td>67066977</td>
    <td>88532410</td>
    <td>107022858</td>
  </tr>
  <tr>
    <td>Total length (>= 10000 bp)</td>
    <td>87449416</td>
    <td>89792771</td>
    <td>106037740</td>
    <td>78870054</td>
    <td>88983381</td>
    <td>127613704</td>
    <td>64123976</td>
    <td>87395602</td>
    <td>100772517</td>
  </tr>
  <tr>
    <td>Total length (>= 25000 bp)</td>
    <td>79279233</td>
    <td>88209660</td>
    <td>95427359</td>
    <td>57823580</td>
    <td>86108746</td>
    <td>104683856</td>
    <td>49954614</td>
    <td>78824780</td>
    <td>78251335</td>
  </tr>
  <tr>
    <td>Total length (>= 50000 bp)</td>
    <td>63563147</td>
    <td>81350788</td>
    <td>75939084</td>
    <td>33653002</td>
    <td>70963916</td>
    <td>62996544</td>
    <td>33674243</td>
    <td>59247731</td>
    <td>49361678</td>
  </tr>
  <tr>
    <td># contigs</td>
    <td>1876</td>
    <td>887</td>
    <td>1980</td>
    <td>3887</td>
    <td>1395</td>
    <td>3604</td>
    <td>2618</td>
    <td>1875</td>
    <td>4672</td>
  </tr>
  <tr>
    <td>Largest contig</td>
    <td>3783513</td>
    <td>3001104</td>
    <td>3735962</td>
    <td>1955127</td>
    <td>2989700</td>
    <td>3561109</td>
    <td>3809581</td>
    <td>3958325</td>
    <td>3733122</td>
  </tr>
  <tr>
    <td>Total length</td>
    <td>89465383</td>
    <td>89991907</td>
    <td>107451818</td>
    <td>85470368</td>
    <td>89620473</td>
    <td>130781131</td>
    <td>68540671</td>
    <td>88957848</td>
    <td>110886168</td>
  </tr>
  <tr>
    <td>GC (%)</td>
    <td>57.92</td>
    <td>57.6</td>
    <td>58.42</td>
    <td>57.28</td>
    <td>57.94</td>
    <td>57.82</td>
    <td>61.11</td>
    <td>59.95</td>
    <td>59.46</td>
  </tr>
  <tr>
    <td>N50</td>
    <td>85291</td>
    <td>156055</td>
    <td>90850</td>
    <td>38522</td>
    <td>92331</td>
    <td>48050</td>
    <td>48310</td>
    <td>74001</td>
    <td>42675</td>
  </tr>
  <tr>
    <td>N75</td>
    <td>43722</td>
    <td>82732</td>
    <td>43651</td>
    <td>20445</td>
    <td>55001</td>
    <td>28615</td>
    <td>23339</td>
    <td>40657</td>
    <td>21910</td>
  </tr>
  <tr>
    <td>L50</td>
    <td>242</td>
    <td>158</td>
    <td>280</td>
    <td>534</td>
    <td>243</td>
    <td>667</td>
    <td>241</td>
    <td>260</td>
    <td>498</td>
  </tr>
  <tr>
    <td>L75</td>
    <td>604</td>
    <td>353</td>
    <td>706</td>
    <td>1297</td>
    <td>559</td>
    <td>1551</td>
    <td>762</td>
    <td>670</td>
    <td>1413</td>
  </tr>
  <tr>
    <td># N's per 100 kbp</td>
    <td>0</td>
    <td>0.22</td>
    <td>0</td>
    <td>0</td>
    <td>0.33</td>
    <td>0</td>
    <td>0</td>
    <td>0.22</td>
    <td>0</td>
  </tr>
</table>

### Coverage estimates after initial assembly (Our goal is 40x):

|  | *T. adustus* | *T. bajacalifornicus* | *T. "raciborskii"* | 
| :------: | :------: |  :------: |  :------: |
|  | **JT2-VF29** |  **ZA 1-7** |  **CCAP 276/35** |
| Total bases | 29,468,000,848.0 |  17,388,312,276.0 |  :------: |
| Genome size | 1,5e+8 |  1,5e+8 |  1,5e+8 |
| Initial coverage | 196.4X |  115.9X |  :------: |
| coverage | 196.4X |  115.9X |  :------: |

<table>
   <tr>
    <td></td>
    <td colspan="3"><i>T. adustus</i> (JT2-VF29)</td>
    <td colspan="3"><i>T. bajacalifornicus</i> (ZA 1-7)</td>
    <td colspan="3"><i>T. "raciborskii"</i> (CCAP 276/35)</td>
  </tr>
   <tr>
    <td></td>
    <td>Shasta</td>
    <td>Flye + 6 polish</td>
    <td>Canu</td>
    <td>Shasta</td>
    <td>Flye + 6 polish</td>
    <td>Canu</td>
    <td>Shasta</td>
    <td>Flye + 6 polish</td>
    <td>Canu</td>
  </tr>
  <tr>
    <td>Initial coverage</td>
    <td colspan="3">196.4X</td>
    <td colspan="3">115.9X</td>
    <td colspan="3">:------:</td>
  </tr>
  <tr>
    <td>Total assembly length</td>
    <td>89465383</td>
    <td>89991907</td>
    <td>107451818</td>
    <td>85470368</td>
    <td>89620473</td>
    <td>130781131</td>
    <td>68540671</td>
    <td>88957848</td>
    <td>110886168</td>
  </tr>
  <tr>
    <td>Initial assembly coverage</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
</table>        
