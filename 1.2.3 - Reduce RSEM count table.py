# -*- coding: utf-8 -*-
"""
Created on Mon Mar  7 15:50:15 2022

@author: dcs839
"""

### Reduce RSEM count table ###

# Reduce count table to exclude the all zero entries #

## Import libraries ##

import os
import numpy as np

## Folder ##

folder = "Lists/Count Tables"

## Files ##

file_in = "Count_table_Wistar_samples_RSEM.csv"
file_out = "Count_table_Wistar_samples_RSEM_Reduced.csv"

## Variable ##
# Create header #
Wistar_header = []
Wistar_header.append('Gene')
for x in range(1,6,1):
    Wistar_header.append("Wistar Control {}".format(x))
for x in range(1,6,1):
    Wistar_header.append("Wistar DIO {}".format(x))


## reduce count table ###

with open(os.path.join(folder,file_out),'w+') as out:
    out.write("{}\n".format(";".join(Wistar_header)))
    with open(os.path.join(folder,file_in),'r') as read:
        next(read)
        for line in read:
            temp_line = line.strip().split(";")
            temp_array = np.array(temp_line[1:],dtype=float)
            sum_of_array = np.sum(temp_array)
            if sum_of_array > 0:
                out.write(line)
            else:
                pass
    read.close
out.close