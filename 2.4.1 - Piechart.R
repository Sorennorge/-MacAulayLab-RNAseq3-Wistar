# Load libraries
library("ggplot2")
library("ggforce") #For exploded chart

# Set working directory #
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Folder #
Folder = "Results/Images"

# File #

File = "Pie_chart_percentage.png"

pie <- data.frame(
  state = c("Other genes - 99.8%","DE genes - 0.2%"),
  focus = c(-0.2, 0),
  start = c(0, 1),
  end = c(0, 2*pi),
  amount = c(21401,46),
  stringsAsFactors = FALSE
)
ggplot(pie) + 
  geom_arc_bar(aes(x0 = 0, y0 = 0, r0 = 0, r = 0.5, amount = amount, 
                   fill = state, explode = focus), stat = 'pie') + 
  scale_fill_manual(values = c("#7FB7DD","#91C6E2"))+
  coord_fixed()+
  theme_void() + 
  theme(legend.position="none")

ggsave(file.path(Folder, File),width=6,height=4,units=c("in"),dpi=600)
                    