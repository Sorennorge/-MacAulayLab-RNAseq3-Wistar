# Libraries #
library("ggplot2")
library("dplyr")
library("RColorBrewer")
library("ggforce") #For exploded chart

# Set working directory #
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Folder #
Folder = "Results/Images"

# File #
File = "Enrichment.png"

# Create Data
data <- data.frame(
  group=c("Metabolite interconversion enzyme",
          "Translational protein",
          "Protein modifying enzyme",
          "Transporter",
          "Membrane traffic protein",
          "Cytoskeletal protein",
          "Scaffold/adaptor protein",
          "Cell adhesion molecule",
          "Extracellular matrix protein",
          "Gene-specific transcriptional regulator",
          "Chromatin/chromatin-binding, or -regulatory protein"),
  value=c(13,4,3,3,3,2,1,1,1,1,1))

# Compute the position of slices #
data <- data %>%
  group_by(group) %>%
  mutate(prop = value / sum(data$value) *100) %>%
  mutate(ypos = cumsum(prop)- 0.5*prop )

#Make order of groups
data$group <- factor(data$group, levels = rev(as.character(data$group)))

#colors
colors = c("#6CA9D8","#73AFDA","#7BB4DC","#82BADE","#8AC0E0","#91C6E2","#98CBE4","#A0D1E6","#A7D7E8","#AFDCEA","#B6E2EC")
plot_colors <- rev(colors)


# Piechart #
ggplot(data, aes(x="", y=prop, fill = group)) +
  geom_bar(stat="identity", width=0.5, color="black")+
  coord_polar("y", start=0)+
  theme_void() +
  theme(legend.position="none")+
  scale_fill_manual(values = plot_colors)
  
# Save plot to file #
ggsave(file.path(Folder, File),width=6,height=4,units=c("in"),dpi=600)


                    