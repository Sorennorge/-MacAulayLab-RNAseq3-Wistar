### If DEseq2 needs to be insalled ###
#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("DESeq2", version = "3.14")

## Import libraries ##
library("DESeq2")

## set working directory ##
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

## Folders ##

Folder1 <- "Lists/Count Tables"
Folder2 <- "Results"

dir.create(file.path(Folder2),recursive = TRUE, showWarnings = FALSE)

## Files ##

File1 = "Count_table_Wistar_samples_RNASTAR_Reduced.csv.csv"
File2 = "DEseq2_DE_genes_Analysis_Wistar.csv"
File3 = "DEseq2_all_genes_Analysis_Wistar.csv"

## Dataset ##
data <- read.table(file.path(Folder1, File1), header=T, sep=";", stringsAsFactors=F, row.names=1)

# create condition / treatment #
sample_info <- data.frame(condition = factor(c(rep("Wistar_control",5),c(rep("Wistar_DIO", 5)))),row.names = factor(colnames(data)))

## create DE dataset in DESeq2 ##

DESeq.ds <- DESeqDataSetFromMatrix(countData = round(data), colData = sample_info, design = ~ condition)
DESeq.ds <- DESeq.ds[rowSums(counts(DESeq.ds)) > 0 , ]
colData(DESeq.ds)$condition <- relevel(colData(DESeq.ds)$condition, "Wistar_control")

## Create rlog and log norm counts ##
DESeq.rlog <- rlog(DESeq.ds, blind = TRUE )
rlog.norm.counts <- assay(DESeq.rlog)
log.norm.counts <- log2(counts.sf_normalized +1)

### Differential expression analysis with DESeq2

#str(colData(DESeq.ds)$condition)
colData(DESeq.ds)$treatment <- relevel(colData(DESeq.ds)$condition, "Wistar_DIO")
DESeq.ds <- DESeq(DESeq.ds)
DGE.results <- results(DESeq.ds, independentFiltering = TRUE, alpha = 0.05)
summary(DGE.results)

### store the genes of interest ###
DGE.results.sorted <- DGE.results[order(DGE.results$padj), ]
DGEgenes <- rownames(subset(DGE.results.sorted, padj < 0.05))

Diff <- DGE.results[DGEgenes,]

# Create output folder
dir.create('Results')

# Write Differential expressed genes to matrix
write.csv2(Diff,file.path(Folder2, File2))
# Write all genes to matrix
write.csv2(DGE.results,file.path(Folder2, File3))
