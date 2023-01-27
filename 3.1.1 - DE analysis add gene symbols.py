# -*- coding: utf-8 -*-
"""
Created on Tue Mar  1 09:08:57 2022

@author: dcs839
"""

### Evaluate DE analysis of Wistar rats -- Add information ###

### Import libraries ###

import os

## Folders ##

folder1 = "Lists/Info/Biomart"
folder2 = "Results"

## Files ##

# file gathered from https://may2021.archive.ensembl.org/biomart/martview/bf2e14cdc13a5a35276820e26937a5a2
# with only ensembl id and gene symbol / name
Biomart = "BioMart_Rnor6.0.txt"

DE_file = "DEseq2_DE_genes_Analysis_Wistar.csv"

Output_file = "DEseq2_DE_genes_Analysis_Wistar_v2.csv"

## Variables ##

Ensembl_to_genes = {}
Header = ['Ensembl', 'Gene Name', 'baseMean', 'log2FoldChange', 'lfcSE', 'stat', 'pvalue', 'padj']
Ensembl_ids = []
Info_dict = {}

### Read files ###

## Biomart ##

with open(os.path.join(folder1,Biomart),'r') as read:
    next(read)
    for line in read:
        line = line.strip().split(",")
        if line[0] not in Ensembl_to_genes:
            Ensembl_to_genes[line[0]] = line[1]
read.close

## DE file - Wistar rat ##

with open(os.path.join(folder2,DE_file),'r') as read:
    next(read)
    for line in read:
        line = line.strip().replace('"','').split(";")
        Ensembl_ids.append(line[0])
        Info_dict[line[0]] = line[1:]
read.close

## Save new file ##

with open(os.path.join(folder2,Output_file),'w+') as out:
    out.write("{}\n".format(";".join(Header)))
    for key in Ensembl_ids:
        if key in Ensembl_to_genes:
            out.write("{};{};{}\n".format(key,Ensembl_to_genes[key].upper(),";".join(Info_dict[key])))
        else:
            out.write("{};;{}\n".format(key,";".join(Info_dict[key])))
out.close
