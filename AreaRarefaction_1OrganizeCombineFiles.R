# AUTHOR:       JENNIFER SELGRATH 
# AFFILIATIONS: Project Seahorse, Institute for the Ocean and Fisheries, University of British Columbia
#               Hopkins Marine Station, Stanford University

# GOAL:         Combine bootstrapping data (created in ArcMap) from each year into a single file. 

###################################################################
# Some references:
#http://biology.uco.edu/personalpages/cbutler/BIO4723/lectures/Week_15_Day_1.pdf
#https://www.uvm.edu/~ngotelli/manuscriptpdfs/Chapter%204.pdf

################################################################
library (vegan)
library (BiodiversityR)
library (ggplot2); library(plyr); library(dplyr); library(RColorBrewer)

######################################################################################
# Preliminary steps in ArcGIS: #######
######################################################################################
# Randomly select a subset of fishing grounds in ArcGIS (1: number of fishers)  for each year. 
# Estimated cumulative area fished by selected fishers from each iteration. 
# Conducted 10 iterations of model for each sample size.  
# Data that is used here is output from those ArcGIS models. There is one .csv file per year.

############################
#Import Data #######

rm(list=ls())
setwd(#set path to working directory here)

# check out file example
test<-read.csv("./data/6AreaEst/AreaEstimate_1960_19by22.csv",stringsAsFactors = FALSE, strip.white = TRUE, na.strings = c("NA"), header=TRUE, sep=",")
head(test)
str(test)
range(test$MODELNO)
range(test$OBJECTID)

# Load Files to R Environment ###############
# set list of files
file_list1 = dir("C:/Users/jselg/Dropbox/0Research/R.projects/LAND_rarefactionCurves/data/6AreaEst")
file_list2 = file_list1[  c(grep('.csv', file_list1))]; file_list2 = file_list2[  c(grep('19by22', file_list2))];file_list2 = file_list2[  c(grep('Area', file_list2))] # gets rid of other files from ArcGIS output
file_list2 

# list of years
years<-c(1960,1970,1980,1990,2000,2010)

# read in .csv files for all years
for (i in 1:length(file_list2)){
  
  oname = paste0("a",years[i])
  assign(oname,read.csv(paste0("./data/6AreaEst/", file_list2[i]), stringsAsFactors = FALSE, strip.white = TRUE, na.strings = c("NA"), header=TRUE, sep=","))

}

###############################
# Check Data to Make Sure 10 reps for all fisher number iterations  ##############
# Each dataset should have 10 iterations. 

head(a1970)
t1<-ddply(a1970,"FISHER_N", summarize,
          n_rep=length(FISHER_N))
t1


#############################################
# assign value to ModelNo: from n=1 to n= max fisher in that year ####################

# list of datasets
a_list<-list(a1960,a1970,a1980,a1990,a2000, a2010)

for (j in 1:length(years)){
  
    # a_list[[j]]$ID=a_list[[j]]$OBJECTID#+1 # calculate an ID for counting #s of Rows #Or FID ## in 2019 not sure why i did this
    
  max_n <- max(a_list[[j]]$FISHER_N) # Find max number of fishers for each year

  #for each iteration of the model assign a new iteration # in the dataframe
    for (i in 1:max_n)
         {
      a_list[[j]]$MODELNO<-rep(1:10, each=max_n)
         }
}

#check results from adding iteration #
a_list[[6]]$MODELNO 



#update files with new data
a1960_2<-a_list[[1]]
a1970_2<-a_list[[2]]
a1980_2<-a_list[[3]]
a1990_2<-a_list[[4]]
a2000_2<-a_list[[5]]
a2010_2<-a_list[[6]] 

#######################################
# Combine all years into 1 file ###########
all2<- rbind(a1960_2,a1970_2,a1980_2,a1990_2,a2000_2,a2010_2)
tail(all2)
range(all2$MODELNO)
str(all2)
head(all2)

# remove misc columns
all3<-select(all2,OBJECTID:FISHER_N,SHAPE_AREA)
all3$AREA_HA=all3$SHAPE_AREA/10000
head(all3)
tail(all3)

write.table(all3,"./results/iterationsByYear.csv", col.names = T, row.names=F,sep=",")
