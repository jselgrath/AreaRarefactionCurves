# AUTHOR:       JENNIFER SELGRATH 
# AFFILIATION:  Project Seahorse, Institute for the Ocean and Fisheries, UBC
#               Hopkins Marine Station, Stanford University
# GOAL:         Theme data for graphs

################################################
# Graphing details, generic
deets<-theme_bw() + #
  theme(panel.grid.minor=element_blank(), 
        panel.grid.major=element_blank(),
        panel.background=element_rect(fill=NA),
        panel.border=element_blank(), #element_rect(fill=NA)
        
        axis.line = element_line(size=.5),
        axis.ticks = element_line(size=.5),
        axis.title = element_text(size=rel(1.7),colour="black", lineheight=1), #face="bold", 
        axis.text = element_text(size=rel(1.5), lineheight=.8,  colour="black"),#, face="bold"),
        axis.title.y=element_text(vjust=1,lineheight=.8),
        axis.title.x=element_text(vjust=.5), 
        
        legend.title=element_text(size=rel(1.7)),
        legend.text=element_text(size=rel(1.5)),
        legend.position=c(.85,.35),
        legend.key = element_rect(colour='white'))

#############################
deets2<-theme_bw() + #
  theme(panel.grid.minor=element_blank(), 
        panel.grid.major=element_blank(),
        panel.background=element_rect(fill=NA),
        panel.border=element_rect(fill=NA),
        
        # axis.line = element_line(size=.5),
        # axis.ticks = element_line(size=.5),
        axis.title = element_text(size=rel(1.2),colour="black", lineheight=.8), #, face="bold"
        axis.text = element_text(size=rel(1), lineheight=.8,  colour="black"),#, face="bold"),
        axis.title.y=element_text(vjust=1,lineheight=.8),
        axis.title.x=element_text(vjust=.5), 
        
        legend.title=element_text(size=rel(1.5)),
        legend.text=element_text(size=rel(1.1)),
        legend.position=c(.8,.25),
        legend.key = element_rect(colour='white'))

# Simulated data #######
deets3<-theme_bw() + #
  theme(panel.grid.minor=element_blank(), 
        panel.grid.major=element_blank(),
        panel.background=element_rect(fill=NA),
        panel.border=element_blank(), #element_rect(fill=NA)
        
        axis.line = element_line(size=.5),
        axis.ticks = element_line(size=.5),
        axis.title = element_text(size=rel(1.7),colour="black", lineheight=1), #face="bold", 
        axis.text = element_text(size=rel(1.5), lineheight=.8,  colour="black"),#, face="bold"),
        axis.title.y=element_text(vjust=1,lineheight=.8),
        axis.title.x=element_text(vjust=.5), 
        
        legend.title=element_text(size=rel(1.7)),
        legend.text=element_text(size=rel(1.5)),
        legend.position=c(.75,.35),
        legend.key = element_rect(colour='white'))