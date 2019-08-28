# AUTHOR:       JENNIFER SELGRATH 
# AFFILIATION:  Project Seahorse, Institute for the Ocean and Fisheries, UBC
#               Hopkins Marine Station, Stanford University

# GOAL:         Species rarefaction curves for fishing ground extent
#################################################
setwd(#set path to working directory here)

# Combine bootstrapping data from each year into a single file. 
# Note: 1970 n=26 is missing one sample. Update code if fix this in ArcGIS.
source("./bin/AreaRarefaction_1OrganizeCombineFiles.R")
# input: .csv files with outputs of simulations from ArcMAP. In folder ./data/6AreaEst
# output: ./results/iterationsByYear.csv

# calculate sample sizes for each year
source("./bin/AreaRarefaction_SampleSize.R")
# input:   ./results/iterationsByYear.csv
# output:  ./doc/sampleSzYr.csv

# to calc summary stats and confidence intervals for each iteration and summarize
source("./bin/AreaRarefaction_2CalculationsConfidenceIntervals.R")
# input:  ./results/iterationsByYear.csv
# output: ./results/extentStats_n_yr.csv
#         ./results/extent_max_90_95.csv   # max extent and 90% & 95% of max extent
#         ./results/extent_90p_mean.csv    # 90% area based on 1990-2010
#         ./results/fisherMinYear_u_rawdata_3yr.csv    # based on ALL CASES >  90% THRESHOLD
#         ./results/fisherMinYear_u_meandata_3yr.csv   # based on MEAN CASES >  90% THRESHOLD

# graph rarefaction curves
source("./bin/AreaRarefaction_graphs.R")
# input:  ./data/extentStats_n_yr.csv
# output: ./doc/GraphRaref_AllYears.tif

# graph modeled data vs field data
source("./bin/AreaRarefaction_EstimatedArea_graphs.R")
# input:  ./data/Ch3_Q1extent_19by22_20160131.csv
# output: ./doc/GraphModelExtent.tiff

# calculate differences between modeled and field data
source("./bin/AreaRarefaction_EstimatedArea_differences.R")
#input:   "Ch3_Q1extent_19by22_20160131.csv"
# output:  NA


############################
# SIMULATED DATA - ACCUM AND RAREF
# simulating species accumulation and rarefaction data
source("./bin/AreaRarefaction_SimulatingData.R")
# input:  NONE - simulate data
# output: simulatedRareAccumCurveData.csv

# graphing simulated accumulation and rarefaction data
source("./bin/AreaRarefaction_SimulatingData_Graph.R")
#input:  simulatedRareAccumCurveData.csv
#        deets.R # controls graphing parameters
#output: ./doc/GraphAccumRaref_SimulationData_Species.tiff
#        ./doc/GraphAccumRaref_SimulationData_Area.tiff

# EXAMPLE DATA - ACCUM AND RAREF
# combine 1 set of raw data and mean data for area sampled for 2010. To use for graphing comparison of accumulation and rarefaction data for area
source("./bin/AreaRarefaction_RawMeanAreaData_2010_combine.R")
#input: ./results/iterationsByYear.csv 
#output: ./results/raw_mean_area2010.csv

# graph 1 set of raw area data and mean area data from 2010
source("./bin/AreaRarefaction_RawMeanAreaData_2010_graph.R")
#input: ./results/raw_mean_area2010.csv
#output: ./doc/GraphAccumRaref_SampleData.tiff
