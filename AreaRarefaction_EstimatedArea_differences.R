# Jennifer Selgrath 
# Project Seahorse, UBC Institute for the Oceans and Fisheries
# Hopkins Marine Station, Stanford Univeristy

# Goal: Estimate percent changes in spatial extent over time
#################################
# library (plyr); 
library(tidyverse);library(arm);library(RColorBrewer)

##############################
remove(list=ls())
dateToday=Sys.Date()
setwd(#set path to working directory here)

# read in data from PhD
d1 <- read.csv("Ch3_Q1extent_19by22_20160131.csv", header=T, stringsAsFactors = FALSE,strip.white = TRUE, na.strings = c("NA","","na"));

# change to working folder for this project
setwd("C:/Users/jselg/Dropbox/0Research/R.projects/LAND_rarefactionCurves/")

# is there a sufficent sample size to estimate the area? 1= yes
d1$samplesz<-1 
d1$samplesz[d1$year<1980]<-0 # years with too small n
head(d1)

#subset data
d2<-d1%>%
	dplyr::select(Shape_Area, area_ha,year,samplesz)%>%
	mutate(area_km=area_ha/100)
d2

# 10  year
d2$increase<-0
for (i in 2:6){
d2$increase[i]<-d2$area_km[i]-d2$area_km[i-1]
}

# 20 year
d2$increase2<-0
for (i in 3:6){
  d2$increase2[i]<-d2$area_km[i]-d2$area_km[i-2]
}
d2

# percent increase 10 year
d2$increase.p<-0
for (i in 2:6){
  d2$increase.p[i]<-d2$increase[i]/d2$area_km[i-1]*100
}
d2

# percent increase, 20 year
d2$increase.p2<-0
for (i in 3:6){
  d2$increase.p2[i]<-d2$increase2[i]/d2$area_km[i-2]*100
}
d2
# note: some of these are incorrect when math was done on previous set of data. Pay attention.
