# -*- coding: utf-8 -*-
"""
Created on Tue Sep 28 08:22:17 2021

@author: dcs839
"""

### Generate count table from gene count files (RNA-STAR) ###

## Import libraries ##

import os

## Folders ##

folder = "Lists/Raw data/Raw_counts"
folder_out = "Lists/Count Tables"

if os.path.exists(folder_out):
    pass
else:
    os.mkdir(folder_out)

## Files ##

file_out = "Count_table_Wistar_samples_RNASTAR.csv"

## Variables

Gene_table = {}
    
## Create header ##
Wistar_header = []
for x in range(1,6,1):
    Wistar_header.append("Wistar Control {}".format(x))
for x in range(1,6,1):
    Wistar_header.append("Wistar DIO {}".format(x))

## create count table ###

for x in range(1,11,1):
    # Go through samples 1-10
    Gene_counts = {}
    with open(os.path.join(folder,"Sample_{}_rawcounts.csv".format(x)),'r') as read:
        next(read)
        for line in read:
            line = line.strip().split(";")
            if line[0] not in Gene_table:
                #if ensembl not in gene table create array of 
                Gene_table[line[0]] = [0] * 10
                Gene_table[line[0]][x-1] += int(line[1])
            else:
                Gene_table[line[0]][x-1] += int(line[1])
    read.close

## Save count table to file ##
with open(os.path.join(folder_out,file_out),'w+') as out:
    out.write("Gene;{}\n".format(";".join(Wistar_header)))
    for key in sorted(Gene_table):
        out.write("{};{}\n".format(key,";".join(map(str,Gene_table[key]))))
out.close
