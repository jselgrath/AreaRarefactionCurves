# Jennifer Selgrath
# Hopkins Marine Station, Stanford University

# Graph rarefaction and accumulation data
###################################################
library(tidyverse)
library(RColorBrewer)
# library(ggrepel)
##########################################################################
rm(list=ls())
setwd(#set path to working directory here)

source("./bin/deets.R") # sets themes

d1<-read_csv(file="./results/simulatedRareAccumCurveData.csv")#,stringsAsFactors = FALSE, strip.white = TRUE, na.strings = c("NA"), header=TRUE, sep=","); 
head(d1)
range(d1$Area)
d1$set<-"Biodiversity"

# create area dataset with a some variablity from species dataset
d2<-d1
d2$set<-"Spatial Diversity"
d2$Area<-d2$Area+dnorm(1,.2,.3)-dnorm(1,.1,.1)
range(d2$Area)

# species
d1$Area=d1$Area*100 

# area
d2$Area=d2$Area*10000

# combine the two versions
d3<-rbind(d1,d2)

# GRAPH #########
ggplot(data=d1, aes(x=Respondents, y=Area)) +
  geom_line(size=1, aes(linetype=Method, colour=Method)) + 
  ylab("No. Species\n")+
  xlab("")+ #Individuals or Samples
  deets3+
  scale_color_discrete(name = "Simulated Data") +
  scale_linetype_discrete(name = "Simulated Data") 
  # ggtitle("Simulated Data")+

  # scale_colour_discrete(name="Simulated Data")

ggsave("./doc/GraphAccumRaref_SimulationData_Species.tiff", width = 6, height=4, dpi=500)

# AREA ####################
ggplot(data=d2, aes(x=Respondents, y=Area)) +
  geom_line(size=1, aes(linetype=Method, colour=Method)) + 
  ylab("Area")+
  xlab("Individuals or Samples")+
  deets3+
  scale_color_discrete(name = "Simulated Data") +
  scale_linetype_discrete(name = "Simulated Data") +
  theme(legend.position = "none")

ggsave("./doc/GraphAccumRaref_SimulationData_Area.tiff", width = 6, height=4, dpi=500)

# COMBINED ##################
ggplot(data=d3, aes(x=Respondents, y=Area)) +
  geom_line(size=1, aes(linetype=Method, colour=Method)) + 
  ylab("Species")+
  xlab("Individuals or Samples")+
  facet_grid(.~set)+
  deets+
  scale_color_discrete(name = "Simulated Data") +
  scale_linetype_discrete(name = "Simulated Data") 

