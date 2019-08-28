# AUTHOR:       JENNIFER SELGRATH 
# AFFILIATION:  Stanford University

# GOAL: Graph mean area rarefaction and raw area accumulation from 1 sample of 2010 data
###############################################
library (tidyverse); library(RColorBrewer)
###############################################
rm(list=ls())
setwd(#set path to working directory here)

source("./bin/deets.R") # sets themes

d1<-read.csv(file="./results/raw_mean_area2010.csv",stringsAsFactors = FALSE, strip.white = TRUE, na.strings = c("NA"), header=TRUE, sep=",")
head(d1)


##########################################################
# GRAPH #########
ylab.text = expression(paste("Mapped Extent (km"^"2",")"))

ggplot(data=d1, aes(x=Respondents, y=Area/100, color=Method)) + geom_line(size=1, aes(linetype=Method)) + 
  ylab(ylab.text)+
  deets+
  scale_color_discrete(name = "Sampled Data") +
  scale_linetype_discrete(name = "Sampled Data") 

ggsave("./doc/GraphAccumRaref_SampleData.tiff", width = 6, height=4)
