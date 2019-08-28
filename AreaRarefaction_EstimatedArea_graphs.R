# Jennifer Selgrath
# Project Seahorse, UBC Institute for the Oceans and Fisheries
# Hopkins Marine Station, Stanford Univeristy

# Goal: Back estimate extent for years with small sample sizes

#################################
library (plyr); library(tidyverse);library(arm);library(RColorBrewer)

##############################
remove(list=ls())
dateToday=Sys.Date()
setwd(#set path to working directory here)

# read in data from PhD
d1 <- read.csv("./data/Extent_19by22.csv", header=T, stringsAsFactors = FALSE,strip.white = TRUE, na.strings = c("NA","","na"));

# is there a sufficent sample size to estimate the area? 1= yes
d1$samplesz<-1 
d1$samplesz[d1$year<1980]<-0 # years with too small n
head(d1)

#subset data
d2<-d1%>%
	dplyr::select(Shape_Area, area_ha,year,samplesz)%>%
	mutate(area_km=area_ha/100)
d2

# for models, with sufficent sample sizes
d3<-d2%>%
	filter(samplesz == 1)
d3

m1<- lm(area_km~year, d3)
display(m1) #r2 = 0.91

m2<- lm(area_km~year +  I(year^2), d3)
display(m2) #r2 = 0.98
anova(m1,m2,test="Chi") # p = 0.09241. Not sig dif.
# https://stat.ethz.ch/R-manual/R-devel/library/stats/html/anova.glm.html

yrs<-seq(1960,2010,10)

predictlinear<-data.frame(year=yrs)
predictlinear$area_km<-  predict(m1, list(year=yrs)) #predict
predictlinear$model<-"1linear"

predictquadratic<-data.frame(year=yrs)
predictquadratic$area_km<-predict(m2, list(year=yrs))
predictquadratic$model<-"2quadratic"

#make data.frame out of predictions
estim<-rbind(predictlinear,predictquadratic)


#combining field data with estimates
d4<-d2%>%
	dplyr::select(year,area_km)
d4$model<-"3fielddata"
d4$year<-as.numeric(d4$year)
d5<-rbind(d4,estim)
d5

d6<-d5

water<- 35408.0645/100  # ocean area for 19x22 km map - from GIS
all<-water+6391.935496/100 #land and mangrove area for 19x22 km map - from GIS

d6$pctOcean<-round((d6$area_km/water*100),2)
d6$pctAll<-round((d6$area_km/all)*100,2)
d6

###################
# ggplot ##########
library(scales)
source("./bin/deets.R")

# set color options
colr <-   scale_colour_brewer(name="Data source",labels=c("3fielddata"="Field data","1linear"="Linear model","2quadratic"= "Quadratic model"), palette="Dark2") #

gry <-   scale_fill_grey(name="Data source",labels=c("3fielddata"="Field data","1linear"="Linear model","2quadratic"= "Quadratic model"), start=.2, end=1)

# set color
clr <-colr;
# clr <-gry

g1<-ggplot(data = d5, aes(x=year,y=area_km, colour = model))+geom_point(size=4)

ylab.text = bquote("Mapped Extent, "~ km^2)

g1 + 
  xlab("Year") + 
  scale_y_continuous(labels = comma)+
  ylab(ylab.text) +  
  geom_line(data=d5, size = .8)+
  clr+
	deets+
	guides(fill=guide_legend(ncol=2))+
  annotate("text", label = "r^2 == 0.98", parse = T, y=198, x = 1963,size=4)+
  annotate("text", label = "r^2 == 0.91", parse = T, y=249, x = 1963,size=4)

ggsave("./doc/GraphModelExtent.tif", width = 6, height=4)

  
