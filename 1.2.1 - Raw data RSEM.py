# -*- coding: utf-8 -*-
"""
Created on Mon Mar  7 15:40:02 2022

@author: dcs839
"""

### Convert all RSEM output files to csv, extracting TPM column ###

## Libraries ##

import os

## Folders ##

Folder_in = "Lists/Raw data/RSEM"
Folder_out = "Lists/Raw data/TPM"

if os.path.exists(Folder_out):
    pass
else:
    os.mkdir(Folder_out)

### Prep raw data to standard input ###

for x in range(1,11,1):
    Ensembl_counts = {}
    with open(os.path.join(Folder_in,"RSEM_Sample_{}.txt".format(x)),'r') as read:
        next(read)
        for line in read:
            line = line.strip().split("\t")
            Ensembl_counts[line[0]] = line[5]
    read.close
    
    ## Save data as ensembl plus TPM
    with open(os.path.join(Folder_out,"Sample_{}_TPM.csv".format(x)),'w+') as out:
        out.write("Entry;TPM\n")
        for key in Ensembl_counts:
            out.write("{};{}\n".format(key,Ensembl_counts[key]))
    out.close