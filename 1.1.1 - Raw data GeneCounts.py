# -*- coding: utf-8 -*-
"""
Created on Tue Sep 28 08:09:09 2021

@author: dcs839
"""

#### Convert RNA-STAR gene count files to csv ###

## Import libraries ##

import os

## Folders #
Folder_in = "Lists/Raw data/GeneCounts"
Folder_out = "Lists/Raw data/Raw_counts"

if os.path.exists(Folder_out):
    pass
else:
    os.mkdir(Folder_out)

### Prep raw data to standard input ###
## Needed are Sample X from RNAstar GeneCounts ##
for x in range(1,11,1):
    Ensembl_counts = {}
    with open(os.path.join(Folder_in,"Sample_{}_GeneCounts.txt".format(x)),'r') as read:
        for _ in range(0,4,1):
            next(read)
        for line in read:
            line = line.strip().split("\t")
            Ensembl_counts[line[0]] = int(line[2])
    read.close
    ## Save data as ensembl plus raw data counts
    with open(os.path.join(Folder_out,"Sample_{}_rawcounts.csv".format(x)),'w+') as out:
        out.write("Entry;raw_count\n")
        for key in Ensembl_counts:
            out.write("{};{}\n".format(key,Ensembl_counts[key]))
    out.close

