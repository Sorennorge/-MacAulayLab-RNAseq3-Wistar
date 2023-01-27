### If DEseq2 needs to be insalled ###
#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("DESeq2", version = "3.14")

library("DESeq2")
#library("reshape2")
library("ggplot2")
#library("dplyr")
#library("edgeR")
#library("vsn")
#library("NMF")
#library("grDevices")
#library("viridis")
#library("tidyverse")
library("pheatmap")
library("RColorBrewer")
#library("tidyr")

# Set working directory #
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

## Folders ##

Folder1 <- "Lists/Count Tables"
Folder2 <- "Results/Images"

dir.create(file.path(Folder2),recursive = TRUE, showWarnings = FALSE)

## Files ##

File1 = "Count_table_Wistar_samples_RNASTAR_Reduced.csv.csv"
File2 = "Heatmap.png"


### load data ###
data <- read.table(file.path(Folder1, File1), header=T, sep=";", stringsAsFactors=F, row.names=1)

## create condition / treatment ##
sample_info <- data.frame(condition = factor(c(rep("Wistar_control",5),c(rep("Wistar_DIO", 5)))),row.names = factor(colnames(data)))

## create DE dataset in DESeq2 ##

DESeq.ds <- DESeqDataSetFromMatrix(countData = round(data), colData = sample_info, design = ~ condition)
DESeq.ds <- DESeq.ds[rowSums(counts(DESeq.ds)) > 0 , ]
colData(DESeq.ds)$condition <- relevel(colData(DESeq.ds)$condition, "Wistar_control")
counts.sf_normalized <- counts(DESeq.ds, normalized = TRUE)

## Create rlog and log norm counts ##
DESeq.rlog <- rlog(DESeq.ds, blind = TRUE )
rlog.norm.counts <- assay(DESeq.rlog)
log.norm.counts <- log2(counts.sf_normalized +1)

### Differential expression analysis with DESeq2 ##
colData(DESeq.ds)$treatment <- relevel(colData(DESeq.ds)$condition, "Wistar_DIO")
DESeq.ds <- DESeq(DESeq.ds)
DGE.results <- results(DESeq.ds, independentFiltering = TRUE, alpha = 0.05)
summary(DGE.results)

DGE.results.sorted <- DGE.results[order(-DGE.results$log2FoldChange), ]
DGEgenes <- rownames(subset(DGE.results.sorted, padj < 0.05))

heatmat_DGEgenes <- log.norm.counts[DGEgenes,]

### Set a color palette
heat_colors <- brewer.pal(10, "RdYlBu")

### Run pheatmap

p<-pheatmap(heatmat_DGEgenes, 
         color = rev(heat_colors),
         cluster_rows = F,
         cluster_cols = F,
         show_rownames = F,
         border_color = "black", 
         fontsize = 5, 
         scale = "row", 
         fontsize_row = 5, 
         height = 20)
p

## Save plot to file ##

ggsave(file.path(Folder2, File2),width=6,height=4,units=c("in"),dpi=600)

## Get the Zscores of the matrix ##

scale_rows = function(x){
  m = apply(x, 1, mean, na.rm = T)
  s = apply(x, 1, sd, na.rm = T)
  return((x - m) / s)
}
zscores <- scale_rows(heatmat_DGEgenes)
