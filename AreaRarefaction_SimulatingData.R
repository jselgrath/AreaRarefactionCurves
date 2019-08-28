# Jennifer Selgrath
# Hopkins Marine Station, Stanford University

# GOAL: Simulate rarefaction and accumulation data
###################################################
library(tidyverse)
################################################
remove(list=ls())

Respondents<-c(1:500)
# Normalized rational model:
# Struucture of model from: https://www.researchgate.net/post/Can_someone_find_a_saturation_function_given_some_data

# f(x) = (x^2 + c*x) / (x^2 + a*x + b)
# Parameters:
a = 2700 # controls up or down of top line
# a = 500
# a = 5000
# b = 60000
b = 40000 # controls elbow of graph
# b = 30000
# b = 5000
# c = 1700 
# c = 3000 
c = 2500 # controls flattening
# c = 100

area<-numeric(length=length(Respondents))
area<- data.frame((Respondents^2 + c*Respondents) / (Respondents^2 + a*Respondents + b))
names(area)<-"Area"
area<-arrange(area,Area)%>%
  mutate(Area=Area)
head(area)

t1<-data.frame(cbind(Respondents,area))
t1$Method<-"Rarefaction"

# simulate sampling/accumulation data
t2<-t1
t2$Method<-"Accumulation"
t2$Area[401:470]<-t2$Area[470]
t2$Area[301:400]<-t2$Area[370]
t2$Area[264:300]<-t2$Area[290]
t2$Area[241:263]<-t2$Area[245]
t2$Area[200:240]<-t2$Area[220]
t2$Area[186:199]<-t2$Area[193]
t2$Area[149:185]<-t2$Area[157]
t2$Area[130:148]<-t2$Area[142]
t2$Area[124:129]<-t2$Area[120]
t2$Area[120:123]<-t2$Area[113]
t2$Area[110:119]<-t2$Area[105]
t2$Area[106:109]<-t2$Area[93]
t2$Area[101:105]<-t2$Area[85]
t2$Area[91:100]<-t2$Area[80]
t2$Area[91:92]<-t2$Area[67]
t2$Area[81:90]<-t2$Area[54]
t2$Area[71:80]<-t2$Area[45]
t2$Area[70:80]<-t2$Area[39]
t2$Area[60:70]<-t2$Area[31]

t2$Area[50:59]<-t2$Area[29]
t2$Area[35:49]<-t2$Area[23]
t2$Area[30:34]<-t2$Area[22]
t2$Area[24:29]<-t2$Area[18]
t2$Area[20:23]<-t2$Area[12]
t2$Area[16:19]<-t2$Area[8]
t2$Area[13:15]<-t2$Area[7]
t2$Area[10:12]<-t2$Area[6]
t2$Area[5:12]<-t2$Area[5]

t2b<-rbind(t1,t2)

setwd(#set path to working directory here)
write.table(t2b,"./results/simulatedRareAccumCurveData.csv", sep=",",col.names = T,row.names = F)
