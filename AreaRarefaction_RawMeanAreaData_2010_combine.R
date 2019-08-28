# AUTHOR:       JENNIFER SELGRATH 
# AFFILIATION:  Stanford University

# GOAL: Combine mean area rarefaction and raw area accumulation from 1 sample of 2010 data
##################################################################
library(plyr);library (tidyverse) 
#########################################################################
rm(list=ls())
setwd(#set path to working directory here)

d1<-read.csv(file="./results/iterationsByYear.csv",stringsAsFactors = FALSE, strip.white = TRUE, na.strings = c("NA"), header=TRUE, sep=",")
head(d1)


##########################################################
# calculate summary statistics for each sample size for each year ########
############################################################

# calc extent statistics for different sample sizes in different years
d2<-ddply(d1, c("YEAR","FISHER_N"), summarise,
          area_u = mean(AREA_HA))
head(d2)

##############################################
#combine d1 and d2 for later graphing ##########
d90<-d1%>%
  filter(MODELNO==1 & YEAR==2010)%>%
  select(Year=YEAR,Respondents=FISHER_N,Area=AREA_HA)
d90$Method<-"Accumulation"
head(d90)

d91<-d2%>%
  filter(YEAR==2010)%>%
  select(Year=YEAR,Respondents=FISHER_N,Area=area_u)
d91$Method<-"Rarefaction"
head(d91)

d92<-rbind(d90,d91)%>%
  arrange(Method,Respondents)
head(d92)
tail(d92)

write.table(d92,"./results/raw_mean_area2010.csv", col.names = T,row.names = F,sep=",")
