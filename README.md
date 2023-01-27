# MacAulayLab (RNAseq3) Wistar #
The work and scripts are done by the MacAulay Lab.\
All programs used are free and open-source.
In the interest of open science and reproducibility, all data and source code used in our research is provided here.\
Feel free to copy and use code, but please cite:\
https://fluidsbarrierscns.biomedcentral.com/articles/10.1186/s12987-022-00335-x \
*Remember* rewrite file_names and folder_names suitable for your pipeline.\
Note: Many of the tables output have converted dot to comma for danish excel annotation.

## The RNAseq and Analysis follows these steps:
## Raw data analysis - Library Build, Mapping and Quantification ##
The analysis uses RNA STAR for mapping and RSEM for TPM quantification.
### RNA-STAR and RSEM Library build and indexing ###

0.1.1 - RNA_STAR_Indexing.sh \
0.2.1 - RSEM_Indexing.sh

### RNA-STAR Mapping and RSEM quantification ###

0.1.2 -RNA_STAR_RNAseq2.sh \
0.2.2 - RSEM_RNAseq2.sh

## Create count tables and reduce for RNA star ##

1.1.1 - Raw data GeneCounts.py
1.1.2 - CeneCount count table.py
1.1.3 - Reduce GeneCount count table.py

## Create count tables and reduce for RSEM (TPM) ##

1.2.1 - Raw data RSEM.py
1.2.2 - RSEM Create count table.py
1.2.3 - Reduce RSEM count table.py

## Differential expression analysis with DEseq2 ##

2.1.1 - DE Analysis Wistar.R

## Volcano plot ##

2.2.1 - DE Analysis Volcano.R

## Heatmap plot ##

2.3.1 - DE Analysis Heatmap.R

## Piechart of differentially expressed genes in percentage ##

2.4.1 - Piechart.R

## Piechart of GO enrichment analysis of protein classes ##

2.5.1 - Piechart Enrichment Analysis.R

## Add gene information ##

3.1.1 - DE analysis add gene symbols.py

## Create supplementary tables ##

4.1.1 - Create supplementary Tables.py
