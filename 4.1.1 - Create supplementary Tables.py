# -*- coding: utf-8 -*-
"""
Created on Fri Apr  8 13:43:25 2022

@author: dcs839
"""

#### Collect all genes for supplementary tables ####

## Import libraries ##

import os
import numpy as np

## Functions ##

def format_float(num):
    return np.format_float_positional(num, trim='-')
def convert_dot_to_comma(lst):
    lst2 = [s.replace('.', ',') for s in lst]
    return lst2

## Folders ##

Folder1 = "Lists/Info/Biomart"
Folder2 = "Lists/Count Tables"
Folder3 = "Results"

Folder_out = "Results/Supplementary Tables"

if os.path.exists(Folder_out):
    pass
else:
    os.mkdir(Folder_out)
    
## Files ##
    
File_Biomart = "BioMart_Rnor6.0.txt"
File_TPM_table = "Count_table_Wistar_samples_RSEM.csv"
File_All_genes = "DEseq2_all_genes_Analysis_Wistar.csv"
File_DE_genes = "DEseq2_DE_genes_Analysis_Wistar.csv"

File_sup_DE = "Supplementary table 1 Wistar DE.csv"
File_sup_All = "Supplementary table 1 Wistar All.csv"

## Global Variables ##

Ensembl_symbols = {}
TPM_dict_control = {}
TPM_dict_HFD = {}
TPM_SD_control = {}
TPM_SD_HFD = {}

Info_all_genes = {}
Info_DE_genes = {}

## Read files ##

# Add gene symbols #
with open(os.path.join(Folder1,File_Biomart),'r') as read:
    next(read)
    for line in read:
        line = line.strip().split(",")
        if line[1] == '':
            Ensembl_symbols[line[0]] = "N/A"
        else:
            Ensembl_symbols[line[0]] = line[1].upper()
read.close

# Find TPM mean & SD
with open(os.path.join(Folder2,File_TPM_table),'r') as read:
    next(read)
    for line in read:
        line = line.strip().split(";")
        # Control #
        control_array = np.array(line[1:6],dtype=float)
        control_mean = np.mean(control_array)
        control_std = np.std(control_array, ddof=1)
        TPM_dict_control[line[0]] = str(control_mean).replace(".",",")
        TPM_SD_control[line[0]] = str(control_std).replace(".",",")
        # HFD #
        HFD_array = np.array(line[6:11],dtype=float)
        HFD_mean = np.mean(HFD_array)
        HFD_std = np.std(HFD_array, ddof=1)
		HFD_std = np.std(HFD_array, ddof=1)
        TPM_dict_HFD[line[0]] = str(HFD_mean).replace(".",",")
        TPM_SD_HFD[line[0]] = str(HFD_std).replace(".",",")
read.close


with open(os.path.join(Folder3,File_All_genes),'r') as read:
    next(read)
    for line in read:
        line = line.strip().split(";")
        Info_all_genes[line[0].replace('"','')] = [line[1],line[2]]
read.close

with open(os.path.join(Folder3,File_DE_genes),'r') as read:
    next(read)
    for line in read:
        line = line.strip().split(";")
        pvalue = format_float(float(str(line[5]).replace(",",".")))
        adj_pvalue = format_float(float(str(line[6]).replace(",",".")))
        Info_DE_genes[line[0].replace('"','')] = [line[1],line[2],pvalue,adj_pvalue]
read.close

with open(os.path.join(Folder_out,File_sup_DE),'w+') as out:
    out.write("Ensembl ID;Gene;MeanBase (DEseq2);Log2FC;Pvalue;Padj\n")
    for key in Info_DE_genes:
        if key in Ensembl_symbols:
            out.write("{};{};{}\n".format(key,Ensembl_symbols[key],";".join(convert_dot_to_comma(Info_DE_genes[key]))))
        else:
            out.write("{};N/A;{}\n".format(key,";".join(convert_dot_to_comma(Info_DE_genes[key]))))
out.close

with open(os.path.join(Folder_out,File_sup_All),'w+') as out:
    out.write("Ensembl ID;Gene;Control Mean (TPM);Control SD (TPM);HFD Mean (TPM);HFD SD (TPM)\n")
    for key in Info_all_genes:
        if key in Ensembl_symbols:
            out.write("{};{};{};{};{};{}\n".format(key,Ensembl_symbols[key],TPM_dict_control[key],TPM_SD_control[key],TPM_dict_HFD[key],TPM_SD_HFD[key]))
        else:
            out.write("{};N/A;{};{};{};{}\n".format(key,TPM_dict_control[key],TPM_SD_control[key],TPM_dict_HFD[key],TPM_SD_HFD[key]))
out.close
