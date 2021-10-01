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
