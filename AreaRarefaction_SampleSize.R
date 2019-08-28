# AUTHOR:       JENNIFER SELGRATH 
# AFFILIATIONS: PROJECT SEAHORSE, UNIVERSITY OF BRITISH COLUMBIA 
#               Hopkins Marine Station, Stanford University

# GOAL:         GOAL: Calculate sample size of respondents for each year
####################################################################
library (vegan)
library (BiodiversityR)
library (ggplot2); library(plyr); library(dplyr); library(RColorBrewer); library(magrittr)

############################################################################################
rm(list=ls())
setwd(#set path to working directory here)

d1<-read.csv(file="./results/iterationsByYear.csv",stringsAsFactors = FALSE, strip.white = TRUE, na.strings = c("NA"), header=TRUE, sep=",")
head(d1)


##########################
# calculate and save range of sample sizes ######
samplesz<-d1%>%
  select(YEAR,FISHER_N)%>%
  group_by(YEAR)%>% 
  top_n(1)%>%
  unique()
samplesz

write.table(samplesz,"./doc/sampleSzYr.csv", col.names = T,row.names = F,sep=",")