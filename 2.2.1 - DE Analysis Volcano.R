### If DEseq2 needs to be insalled ###
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
    BiocManager::install("DESeq2", version = "3.16")

library("DESeq2")
library("ggplot2")

# Set working directory #
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

## Folders ##

Folder1 <- "Lists/Count Tables"
Folder2 <- "Results/Images"

dir.create(file.path(Folder2),recursive = TRUE, showWarnings = FALSE)

## Files ##

File1 = "Count_table_Wistar_samples_RNASTAR_Reduced.csv.csv"
File2 = "Volcano_plot.png"


### load data ###
data <- read.table(file.path(Folder1, File1), header=T, sep=";", stringsAsFactors=F, row.names=1)

## create condition / treatment ##
sample_info <- data.frame(condition = factor(c(rep("Wistar_control",5),c(rep("Wistar_DIO", 5)))),row.names = factor(colnames(data)))

## create DE dataset in DESeq2 ##

DESeq.ds <- DESeqDataSetFromMatrix(countData = round(data), colData = sample_info, design = ~ condition)

## DESeq.ds
DESeq.ds <- DESeq.ds[rowSums(counts(DESeq.ds)) > 0 , ]
colData(DESeq.ds)$condition <- relevel(colData(DESeq.ds)$condition, "Wistar_control")

### Differential expression analysis with DESeq2 ##
colData(DESeq.ds)$treatment <- relevel(colData(DESeq.ds)$condition, "Wistar_DIO")
DESeq.ds <- DESeq(DESeq.ds)
DGE.results <- results(DESeq.ds, independentFiltering = TRUE, alpha = 0.05)

## Sort data and add color scheme (A,B,C) to the genes ##
DGE.results.sorted <- DGE.results[order(DGE.results$log2FoldChange), ]
# A -> not differential expressed #
DGE.results.sorted$diffexpressed <- "A"
# B -> differential expressed (up) #
DGE.results.sorted$diffexpressed[DGE.results.sorted$log2FoldChange > 0.0 & DGE.results.sorted$padj < 0.05] <- "B"
# C -> differential expressed (down) #
DGE.results.sorted$diffexpressed[DGE.results.sorted$log2FoldChange < 0.0 & DGE.results.sorted$padj < 0.05] <- "C"

## Sort the data so the differential expressed is on top ##
data_volcano <- data.frame(x = DGE.results.sorted$log2FoldChange, y = DGE.results.sorted$padj, diff = DGE.results.sorted$diffexpressed)
data_volcano.sorted = data_volcano[order(data_volcano$diff), ]

## Choose color scheme ##
mycolors <- c("deepskyblue2", "firebrick2", "grey70")
names(mycolors) <- c("C", "B", "A")

## GGplot ##
p <- ggplot(data_volcano.sorted, aes(x,-log(y,10),colour=diff)) + 
  geom_vline(xintercept=c(0),linetype = "dashed" ,col="grey50") +
  geom_hline(yintercept=-log10(0.05),linetype = "dashed", col="grey50")+
  geom_hline(yintercept=-log10(1),linetype = "dashed", col="grey50")+
  geom_point(aes(colour=diff, fill=diff),size=2,shape=21,colour = "black",stroke = 0.25) +
  theme_bw()+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
  scale_fill_manual(values = mycolors) +
  scale_x_continuous(name="Log2 fold change", limits=c(-1, 1),breaks=c(-1,-0.5,0,0.5,1)) +
  scale_y_continuous(name="-Log10 adjusted p-value", limits=c(0, 3),breaks=c(-1,0, 1, 2,3,4,5,6))+
  theme(legend.position="none")

## Plot volcano ##
p

## Save image ##
ggsave(file.path(Folder2, File2),width=8,height=8,units=c("in"),dpi=1200)
