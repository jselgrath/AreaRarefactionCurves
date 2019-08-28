# AUTHOR:       JENNIFER SELGRATH 
# AFFILIATION:  Project Seahorse, Institute for the Oceans and Fisheries, UBC
#               Hopkins Marine Station, Stanford University

# GOAL:         to calc summary stats and confidence intervals for each iteration and summarize data
##################################################################

######################
# some references
#####################
# Payton et al 2003 = CI reference. And Gotelli and Colwell Ch4. p47
# http://www.r-tutor.com/elementary-statistics/interval-estimation/interval-estimate-population-mean-unknown-variance

# upper and lower CI
# qt for 84% CI = 1-((1-.84)/2) = .92
# qt for 95% CI = 1-((1-.95)/2) = .975

#########################################################################
library (vegan); library (BiodiversityR)
library(plyr);library (tidyverse); library(glue)

#########################################################################
rm(list=ls())
setwd(#set path to working directory here)

d1<-read_csv(file="./results/iterationsByYear.csv")#,stringsAsFactors = FALSE, strip.white = TRUE, na.strings = c("NA"), header=TRUE, sep=",")
d1

##########################################################
# calculate summary stats and confidence intervals for each sample size for each year #######

# calc extent statistics for different sample sizes in different years
d2<-ddply(d1, c("YEAR","FISHER_N"), summarise,
            area_u = mean(AREA_HA),
            area_sd = sd(AREA_HA),
            area_se = sd(AREA_HA)/sqrt(length(FISHER_N)), 
            area_ci95 = qt(.975, df=length(FISHER_N)-1)*area_se,   
            area_ci84 = qt(.920, df=length(FISHER_N)-1)*area_se)  
tail(d2)

write.table(d2,"./results/extentStats_n_yr.csv", col.names = T,row.names = F,sep=",")

min(d2$area_u)

head(d2)

########################################################################
# calc max area and 90% of area from mean (d2) values ########
Yrmax<-ddply(d2, c("YEAR"), summarise,
             area_max = round(max(area_u),2),
             area_max90 = round(area_max*.90,2),   # 90% of max mean area 
             area_max95 = round(area_max*.95,2));  # 95% of max mean area 
Yrmax
write.table(Yrmax,"./doc/extent_max_90_95.csv", col.names = T,row.names = F,sep=",")


###############################
# estimate mean max area for three years that reach an asymptote######
# mean 90% Area value for 1990, 2000, 2010

# chose these years manually
mean100p<-mean(c(Yrmax$area_max[4], Yrmax$area_max[5], Yrmax$area_max[6]))
mean100p

mean90p<-mean(c(Yrmax$area_max90[4], Yrmax$area_max90[5], Yrmax$area_max90[6]))
mean90p<-data.frame(mean90p)
mean90p$yrs<-3
mean90p
# mean90p_3yrs<-mean90p$area_max90

names(mean90p)<-c("mean90p","yrs")
mean90p

write.table(mean90p,"./doc/extent_90p_mean.csv", col.names = T,row.names = F,sep=",")

#############
# CALC SAMPLE SIZE NEEDED TO REACH 90% of area ###########
##############

# 90% of (mean) area fished using last 2 or last 3 years
# 28484.03 = mean90p_3yrs (1990,2000,2010))


######################################################
# For 3 year average 
# minimum sample from raw data
head(d1)

################################################################
# estimate the minimum number of respondents needed in that year to reach that extent #########
# this uses the RAW DATA

# ALL CASES GREATER THAN THE 90% THRESHOLD By YEAR
d3<-filter(d1, AREA_HA > mean90p_3yrs)%>% # Filter samples when the AREA_HA sampled is > 90% of the total fished area (mean) from 1990-2010
  ddply(c("YEAR","MODELNO"),summarise,    # Estimate the smallest sample size for each iteration (=MODELNO) in each year that met the 90% cutoff
                    fishern_min1= min(FISHER_N)) %>%
  ddply(c("YEAR"),summarise,                  # for each year calculate
        fishern_min= min(fishern_min1),       # lowest sample size in a year
        fishern.u= mean(fishern_min1),    # mean lowest sample size in a year
        fishern.sd= round(sd(fishern_min1),2),     # sd lowest sample size in a year
        fishern.se= round(sd(fishern_min1)/sqrt(length(fishern_min1)),2)) # se lowest sample size in a year
d3$model<-"3yr.min"  
d3

d3b<-(d3)
d3b$mean2<-paste0(d3b$fishern.u, " (", d3b$fishern.se,")")
d3b<-select(d3b,YEAR, fishern_min, mean2)

colnames(d3b)<-c("Year","Minimum no. respondents", "Mean no. respondents (se)")
d3b

#save
write.table(d3b,"./doc/fisherMinYear_u_rawData3yr.csv", sep=",", col.names=T, row.names=F)


#######################
# merge year max and fisher no. (raw) tables for paper
d3c<-merge(d3,Yrmax)
d3c$mean2<-paste0(d3c$fishern.u, " (", d3c$fishern.se,")")

d3c<-select(d3c,YEAR, area_max, area_max90,fishern_min, mean2)
colnames(d3c)<-c("Year","Area mapped (max, ha)", "Area mapped (90%, ha)", "No. respondents (min)", "No. respondents (mean (se))")
d3c

write.table(d3c,"./doc/yearAreaFisherMin_u_rawData3yr.csv", sep=",", col.names=T, row.names=F)

##########################################################################
#  min and mean number of respondents for large enough sample sizes, by year ##############
d1b<-d1
d1b$no<-3
d3d<-filter(d1b, AREA_HA > mean90p$mean90p)%>% # Filter samples when the AREA_HA sampled is > 90% of the total fished area (mean) from 1990-2010
  ddply(c("YEAR","MODELNO","no"),summarise,    # Estimate the smallest sample size for each iteration (=MODELNO) in each year that met the 90% cutoff
        fishern_min1= min(FISHER_N))%>%
  ddply(c("no"),summarise,                  # for each year calculate
        fishern_min= min(fishern_min1),       # lowest sample size in a year
        fishern.u= mean(fishern_min1),    # mean lowest sample size in a year
        fishern.sd= round(sd(fishern_min1),2),     # sd lowest sample size in a year
        fishern.se= round(sd(fishern_min1)/sqrt(length(fishern_min1)),2))%>% # se lowest sample size in a year
  select(fishern_min:fishern.se)%>%
  mutate(model="summarized values (1980-2010), min")
d3d

write.table(d3d,"./doc/fisherMinMean_1980_2010.csv", sep=",", col.names=T, row.names=F)


####################################################
#what percent of samples are large enough?
d.sample<-filter(d1, AREA_HA > mean90p$mean90p)%>%
  ddply(c("YEAR"),summarise,
        samples.n=length(FISHER_N))
d.sample

tot.sample<- d1%>%
  ddply(c("YEAR"),summarise,
        samples.n=length(FISHER_N))%>%
  filter(YEAR>=1980)

sample<-data.frame(cbind(d.sample,tot.sample))%>%
  select(YEAR,samples.lg=samples.n,samples.tot=samples.n.1)
sample$pct<-sample$samples.lg/sample$samples.tot
sample

##########################################################
# estimate the mean number of respondents needed in that year to reach 90% extent
# this uses the mean values for each iteration size per year
# slightly different, but similar to d3 above. and simlar results

# area statistics ##################
head(d2)
d4<-filter(d2, area_u > mean90p$mean90p)%>% # filter data for sample sizes that mapped an area larger than 90% of the total area mapped
  group_by(YEAR)%>% # only for 1980 and later
  top_n(-1,wt=area_u)%>%
  select(YEAR:area_ci84)
d4
d4$model<-"3yr.u"
d4 # looks like individuals covered less space early on, but with less overlap

# fisher statistics ############
#  min and mean number of respondents for large enough sample sizes
d5<-filter(d2, area_u > mean90p$mean90p)%>% 
  ddply(c("YEAR"),summarise, 
        fishern_min= min(FISHER_N),       # lowest sample size in a year
        fishern.u= mean(FISHER_N),    # mean lowest sample size in a year
        fishern.sd= round(sd(FISHER_N),2),     # sd lowest sample size in a year
        fishern.se= round(sd(FISHER_N)/sqrt(length(FISHER_N)),2)) # se lowest sample size in a year
d5$model<-"3yr.mean" 
d5  

write.table(d5,"./doc/fisherMinYear_u_meandata_3yr.csv", sep=",", col.names=T, row.names=F)


