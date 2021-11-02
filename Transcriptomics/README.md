## Differential expression during desiccation and rehydration in two desert and one aquatic sister species

## Introduction
Tetradesmus bajacalifornicus (ZA1-7) and T. adustus (JT2-VF29) are closely related desert species, T. "raciborskii" (CCAP 276/35) is an aquatic species sister to both of them. Algae were slowly desiccated until the RH in the chamber reached 11% (Alpha in my lab notes).

### Directory Layout
The data used in this project can be accessed in the Xanadu cluster at the following directory: 'LLewis_lab'
<br>
To view the files use the following command:
<br>
<pre style="color: silver; background: black;">-bash-4.2$ ls LLewis_lab
data 01_QC 01.2_Kraken 02_Assembly_Trinity 03_Coding_Regions 04_Clustering 05_AssemblyEvaluation 06_RemoveContaminants</pre>

These are the associated names of all the samples given in the directory ("Barcode" is a unique number of the sample in the whole of the experiment):
<br>

| Species| Strain | Hydration State | Sample | Barcode |
| :------: | :------: |  :------: |  :------: | :------: |
| *T. adustus* | JT2-VF29 | Hydrated | ET010 | 127 |
| *T. adustus* | JT2-VF29 | Hydrated | ET013 | 304 |
| *T. adustus* | JT2-VF29 | Hydrated | ET018 | 190 |
| *T. adustus* | JT2-VF29 | Desiccated | ET022 | 9 |
| *T. adustus* | JT2-VF29 | Desiccated | ET025 | 322 |
| *T. adustus* | JT2-VF29 | Desiccated | ET030 | 482 |
| *T. adustus* | JT2-VF29 | Rehydrated 10 min | ET003 | 193 |
| *T. adustus* | JT2-VF29 | Rehydrated 10 min | ET020 | 224 |
| *T. adustus* | JT2-VF29 | Rehydrated 10 min | ET028 | 111 |
| *T. adustus* | JT2-VF29 | Rehydrated 24 hrs | ET016 | 615 |
| *T. adustus* | JT2-VF29 | Rehydrated 24 hrs | ET017 | 400 |
| *T. adustus* | JT2-VF29 | Rehydrated 24 hrs | ET027 | 169 |
| *T. bajacalifornicus* | ZA 1-7 | Hydrated | ET008 | 133 |
| *T. bajacalifornicus* | ZA 1-7 | Hydrated | ET011 | 267 |
| *T. bajacalifornicus* | ZA 1-7 | Hydrated | ET012 | 63 |
| *T. bajacalifornicus* | ZA 1-7 | Desiccated | ET001 | 577 |
| *T. bajacalifornicus* | ZA 1-7 | Desiccated | ET029 | 432 |
| *T. bajacalifornicus* | ZA 1-7 | Desiccated | ET032 | 110 |
| *T. bajacalifornicus* | ZA 1-7 | Rehydrated 10 min | ET015 | 26 |
| *T. bajacalifornicus* | ZA 1-7 | Rehydrated 10 min | ET021 | 137 |
| *T. bajacalifornicus* | ZA 1-7 | Rehydrated 10 min | ET031 | 582 |
| *T. bajacalifornicus* | ZA 1-7 | Rehydrated 24 hrs | ET002 | 157 |
| *T. bajacalifornicus* | ZA 1-7 | Rehydrated 24 hrs | ET033 | 464 |
| *T. bajacalifornicus* | ZA 1-7 | Rehydrated 24 hrs | ET034 | 260 |
| *T. "raciborskii"* | CCAP 276/35 | Hydrated | ET007 | 217 |
| *T. "raciborskii"* | CCAP 276/35 | Hydrated | ET009 | 245 |
| *T. "raciborskii"* | CCAP 276/35 | Hydrated | ET014 | 358 |
| *T. "raciborskii"* | CCAP 276/35 | Desiccated | ET004 | 361 |
| *T. "raciborskii"* | CCAP 276/35 | Desiccated | ET023 | 602 |
| *T. "raciborskii"* | CCAP 276/35 | Desiccated | ET036 | 583 |
| *T. "raciborskii"* | CCAP 276/35 | Rehydrated 10 min | ET005 | 13 |
| *T. "raciborskii"* | CCAP 276/35 | Rehydrated 10 min | ET019 | 366 |
| *T. "raciborskii"* | CCAP 276/35 | Rehydrated 10 min | ET026 | 174 |
| *T. "raciborskii"* | CCAP 276/35 | Rehydrated 24 hrs | ET006 | 176 |
| *T. "raciborskii"* | CCAP 276/35 | Rehydrated 24 hrs | ET024 | 166 |
| *T. "raciborskii"* | CCAP 276/35 | Rehydrated 24 hrs | ET035 | 56 |

## Quality Assesment
We summarized the libraries using <pre style="color: silver; background: black;"> FastQC </pre> and <pre style="color: silver; background: black;"> MultiQC </pre>. The full script is called 'fastqc_raw.sh'. Based on the results, all libraries with less than 10M total reads were eliminated (libraries 24 & 35). Since both of these low-quality libraries belong to the same set of samples, the whole set (*T. "raciborskii"* Rehydrated 24 hrs) was eliminated from the downstream analysis.

## Contaminant Screening
To screen contaminants I used Kraken 2 first, with general contaminant library (includes human genome), then -- without it. In both cases the analysis was performed on two libraries per species: one with the highest genome mapping rate, another -- with th lowest. Script 'kraken2.sh':
<pre style="color: silver; background: black;">
#!/bin/bash
#SBATCH --job-name=Kraken2
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=200G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=elizaveta.terlova@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date


#cat ../01_Trimmomatic/573_paired_1.fq ../01_Trimmomatic/574_paired_1.fq ../01_Trimmomatic/575_paired_1.fq ../01_Trimmomatic/576_paired_1.fq ../01_Trimmomatic/577_paired_1.fq ../01_Trimmomatic/578_paired_1.fq ../01_Trimmomatic/579_paired_1.fq ../01_Trimmomatic/580_paired_1.fq >> cat_R1.fq

#cat ../01_Trimmomatic/573_paired_2.fq ../01_Trimmomatic/574_paired_2.fq ../01_Trimmomatic/575_paired_2.fq ../01_Trimmomatic/576_paired_2.fq ../01_Trimmomatic/577_paired_2.fq ../01_Trimmomatic/578_paired_2.fq ../01_Trimmomatic/579_paired_2.fq ../01_Trimmomatic/580_paired_2.fq >> cat_R2.fq


module load kraken/2.0.8-beta
module load jellyfish/2.2.6

for i in 25 28 23 5 12 34

do kraken2 -db /isg/shared/databases/kraken2/Minikraken2_v1 \
        --paired ~/2021DA_transcriptomes/01_QC/QC_tworuns_June2021/trim_ET${i}_R1.fastq.gz ~/2021DA_transcriptomes/01_QC/QC_tworuns_June2021/trim_ET${i}_R2.fastq.gz \
        --use-names \
        --threads 16 \
        --output lib${i}_general.out \
        --unclassified-out lib${i}_unclassified#.fastq \
        --classified-out lib${i}_classified#.fastq      \
        --report lib${i}_kraken_report.txt \
        --use-mpa-style
done
date
</pre>

Results:

<table>
  <tr>
    <td></td>
    <td colspan="4"><i>T. adustus</i> (JT2-VF29)</td>
    <td colspan="4"><i>T. bajacalifornicus</i> (ZA 1-7)</td>
    <td colspan="4"><i>T. "raciborskii"</i> (CCAP 276/35)</td>
  </tr>
  <tr>
    <td>Library</td>
    <td colspan="2">25</td>
    <td colspan="2">28</td>
    <td colspan="2">12</td>
    <td colspan="2">34</td>
    <td colspan="2">23</td>
    <td colspan="2">5</td>
  </tr>
  <tr>
    <td>% mapped to Canu</td>
    <td colspan="2">93.63%</td>
    <td colspan="2">58.77%</td>
    <td colspan="2">70.33%</td>
    <td colspan="2">10.18%</td>
    <td colspan="2">90.41%</td>
    <td colspan="2">22.84%</td>
  </tr>
  <tr>
    <td>Database</td>
    <td>with human</td>
    <td>w/o human</td>
    <td>with human</td>
    <td>w/o human</td>
    <td>with human</td>
    <td>w/o human</td>
    <td>with human</td>
    <td>w/o human</td>
    <td>with human</td>
    <td>w/o human</td>
    <td>with human</td>
    <td>w/o human</td>
  </tr>
  <tr>
    <td>Seqs processed</td>
    <td colspan="2">15104815</td>
    <td colspan="2">11917932</td>
    <td colspan="2">15431843</td>
    <td colspan="2">14574856</td>
    <td colspan="2">16173726</td>
    <td colspan="2">36688438</td>
  </tr>
  <tr>
    <td>% seqs classified</td>
    <td>5.66%</td>
    <td>1.57%</td>
    <td>62.17%</td>
    <td>51.57%</td>
    <td>5.99%</td>
    <td>3.11%</td>
    <td>10.60%</td>
    <td>9.31%</td>
    <td>8.66%</td>
    <td>2.13%</td>
    <td>17.06%</td>
    <td>3.94%</td>
  </tr>
  <tr>
    <td># seqs classified</td>
    <td>855677</td>
    <td>236933</td>
    <td>7409791</td>
    <td>6145581</td>
    <td>1400401</td>
    <td>502922</td>
    <td>6257399</td>
    <td>3414207</td>
    <td>923605</td>
    <td>329344</td>
    <td>1545398</td>
    <td>574921</td>
  </tr>
  <tr>
    <td>% seqs unclassified</td>
    <td>94.34%</td>
    <td>98.43%</td>
    <td>37.83%</td>
    <td>48.43%</td>
    <td>94.01%</td>
    <td>96.89%</td>
    <td>89.40%</td>
    <td>90.69%</td>
    <td>91.34%</td>
    <td>97.87%</td>
    <td>82.94%</td>
    <td>96.06%</td>
  </tr>
  <tr>
    <td># seqs unclassified</td>
    <td>14249138</td>
    <td>14867882</td>
    <td>4508141</td>
    <td>55772351</td>
    <td>14773325</td>
    <td>15670804</td>
    <td>30431039</td>
    <td>33274231</td>
    <td>14508238</td>
    <td>15102499</td>
    <td>13029458</td>
    <td>13999935</td>
  </tr>
  <tr>
    <td>d_Bacteria</td>
    <td>595568</td>
    <td>212915</td>
    <td>7036985</td>
    <td>6124103</td>
    <td>656683</td>
    <td>297616</td>
    <td>1130668</td>
    <td>523556</td>
    <td>1083787</td>
    <td>481942</td>
    <td>4604106</td>
    <td>3324016</td>
  </tr>
  <tr>
    <td>d_Eukaryota</td>
    <td>234911</td>
    <td>"---"</td>
    <td>243067</td>
    <td>"---"</td>
    <td>233196</td>
    <td>"---"</td>
    <td>353158</td>
    <td>"---"</td>
    <td>253072</td>
    <td>"---"</td>
    <td>1503982</td>
    <td>"---"</td>
  </tr>
  <tr>
    <td>d_Archaea</td>
    <td>14592</td>
    <td>645</td>
    <td>3728</td>
    <td>280</td>
    <td>18357</td>
    <td>896</td>
    <td>14415</td>
    <td>7383</td>
    <td>42954</td>
    <td>2821</td>
    <td>44633</td>
    <td>17713</td>
  </tr>
  <tr>
    <td>d_Viruses</td>
    <td>4075</td>
    <td>4722</td>
    <td>1489</td>
    <td>2932</td>
    <td>6145</td>
    <td>8359</td>
    <td>30533</td>
    <td>7802</td>
    <td>6305</td>
    <td>3611</td>
    <td>13695</td>
    <td>26439</td>
  </tr>
</table>

## De Novo Transcriptome Assembly with Trinity
To create the reference transcriptome we first assembled each library separately, then combined them by species, clustered the assembly into groups, each of which hopefully represents a transcript.

The script, which we used to assemble each library 'trinity.sh':
<pre style="color: silver; background: black;"> </pre>

## Making a Reference Transcriptome
We need to create a single reference transcriptome per species containing one reference transcript per gene. To create such a reference we used two pipelines: TransDecoder-Hummer-VSearch and EviGene.

### 1.1. Identifying Coding Regions with TransDecoder and Hummer

### 1.2. Clustering with VSearch

### 1.3 Contaminant Screening with EnTAP (all libraries at once)
DIAMOND best overall results

| | <i>T. adustus</i> | <i>T. bajacalifornicus</i> | <i>T. "raciborskii"</i> |
| :------: | :------: |  :------: |  :------: |
| <b>Total unique contaminants<b> | 166(1.05%) |  236 (1.21%) |  223 (0.98%) |
| <b>Amoebozoa<b> | 4.22% |  11(4.66%) |  7(3.14%) |
| <b>Fungi<b> | 50(30.12%) |  81(34.32%) |  51(22.87%) |
| <b>Ciliophora<b> | 4(2.41%) |  1(0.42%) |  4(1.79%) |
| <b>Bacteria<b> | 105(63.25%) |  143(60.59%) |  161(72.20%) |
| :------: | :------: |  :------: |  :------: |
| <b>Top 10 contaminants<b> | <i>Saccharomyces cerevisiae<i> 16(9.64%) |  <i>Schizosaccharomyces pombe<i> 25(10.59%) |  <i>Schizosaccharomyces pombe<i> 17(7.62%) |
|  | <i>Synechocystis<i> sp. 12(7.23%) | <i>Bacillus subtilis<i> 16(6.78%)  | <i>Yersinia enterocolitica<i> 15(6.73%) |
|  | <i>Yersinia enterocolitica<i> 11(6.63%) | <i>Saccharomyces cerevisiae<i> 15(6.36%) | <i>Bacillus subtilis<i> 13(5.83%) |
|  | <i>Schizosaccharomyces pombe<i> 10(6.02%) | <i>Yersinia enterocolitica<i> 14(5.93%)  | <i>Saccharomyces cerevisiae<i> 12(5.38%) |
|  | <i>Staphylococcus epidermidis<i> 9(5.42%) | <i>Escherichia coli<i> 11(4.66%) | <i>Escherichia coli<i> 11(4.93%) |
|  | <i>Escherichia coli<i> 9(5.42%) | <i>Dictyostelium discoideum<i> 11(4.66%) | <i>Xanthomonas campestris<i> 9(4.04%) |
|  | <i>Dictyostelium discoideum<i> 7(4.22%) | <i>Synechocystis<i> sp. 11(4.66%) | <i>Synechocystis<i> sp. 9(4.04%) |
|  | <i>Candida albicans<i> 6(3.61%) | <i>Candida albicans<i> 10(4.24%) | <i>Thermotoga maritima<i> 7(3.14%) |
|  | <i>Bacillus subtilis<i> 6(3.61%) | <i>Desulforudis audaxviator<i> 7(2.97%) | <i>Dictyostelium discoideum<i> 7(3.14%) |
|  | <i>Neurospora crassa<i> 5(3.01%) | <i>Synechococcus<i> sp. 7(2.97%) | <i>Caldanaerobacter subterraneus<i> 6(2.69%) |
| :------: | :------: |  :------: |  :------: |
| <b>Top 10 alignments by species<b> | :------: |  <i>Monoraphidium neglectum<i> 5874(29.99%)| <i>Monoraphidium neglectum<i>  6003(26.52%) |
| :------: | :------: |  <i>Chlamydomonas reinhardtii<i> 4310(22.01%) | <i>Chlamydomonas reinhardtii<i> 4607(20.35%) |
| :------: | :------: |  <i>Volvox carteri f. nagariensis<i> 2748(14.03%) | <i>Volvox carteri f. nagariensis<i> 3035(13.41%) |
| :------: | :------: |  <i>Coccomyxa subellipsoidea<i> 1912(9.76%) | <i>Coccomyxa subellipsoidea<i> 1770(7.82%) |
| :------: | :------: |  <i>Chlorella variabilis<i> 912(4.66%) | <i>Mus musculus<i> 1684(7.44%) |
| :------: | :------: |  <i>Mus musculus<i> 463(2.36%) | <i>Chlorella variabilis<i> 938(4.14%) |
| :------: | :------: |  <i>Arabidopsis thaliana<i> 435(2.22%) | <i>Rhodamnia argentea<i> 525(2.32%) |
| :------: | :------: |  <i>Auxenochlorella protothecoides<i> 414(2.11%) | <i>Auxenochlorella protothecoides<i> 458(2.02%) |
| :------: | :------: |  <i>Rhodamnia argentea<i> 138(0.70%) | <i>Arabidopsis thaliana<i> 457(2.02%) |
| :------: | :------: |  <i>Micromonas commoda<i> 103(0.53%) | <i>Drosophila melanogaster<i> 186(0.82%) |        


### 2.1 EviGene Pipeline

### 2.2 Contaminant screening with EnTAP
Protein files for each library from EviGene were run through EnTAP to identify contaminants for removal. We used RefSeq Diamond database, 70/70 coverage; amoebozoa, cilliates, fungi, and bacteria were indicated as possible contaminants.
        
General results are presented on this figure:
[trinity_evigene_entap](https://github.com/eterlova/DAscripts/blob/main/Transcriptomics/Images/trinity_evigene_entap.png "EnTAP 70/70 on EviGene"
