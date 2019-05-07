###################################################################################################
##########################           MALTX - Make Scatterplots           ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 12/04/2018                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
#<<USE

#This Script is used to create the Scatterplots that will be presented on the poster and paper.

#USE
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

##########################################
#### Load the Libraries Needed Into R ####
##########################################

library(mgcv)
library(visreg)
library(ggplot2)
library(cowplot)
library(RColorBrewer)
library(svglite)

#######################
#### Load the Data ####
#######################

RDS<- readRDS("/dfs1/som/rao_col/maltx/datasets/clinical/n50_Demo+MDD+MAL_20181203.rds")
CSV<-read.csv("/dfs1/som/rao_col/maltx/datasets/neuroimaging/n26_ashs_20181109.csv")
DATA<-merge(RDS,CSV, by=c("SUBID"))

#######################
#### Define Models ####
#######################

ResponceVars <- names(DATA)[grep("right_CA2",names(DATA))]

Models <- lapply(ResponceVars, function(x) {
  gam(substitute(i ~ s(Age,k=4) + Sex + CAI_SS_Total, list(i = as.name(x))), method="REML", data = DATA)
})

Results <- lapply(Models, summary)

###################################################
#### Gather uncorrected and corrected P-Values ####
###################################################

p_val <- sapply(Models, function(v) summary(v)$p.table[3,4])
p_val <- as.data.frame(p_val)
p_val_round <- round(p_val,3)
p_val_fdr <- p.adjust(p_val[,1],method="fdr")
p_val_fdr <- as.data.frame(p_val_fdr)
p_val_fdr_round <- round(p_val_fdr,3)

#######################################################
#### Check The Models that Survived FDR Correction ####
#######################################################

Results_fdr <- row.names(p_val_fdr)[p_val_fdr<0.05]
Results_fdr_names <- ResponceVars[as.numeric(Results_fdr)]
Results_output <- Results[as.numeric(Results_fdr)]

################################################
### PLOT ARI as a Predictor of CT Network 18 ### 
################################################

plotdata <- visreg(Models[[1]],'CAI_SS_Total',type = "conditional",scale = "linear", plot = FALSE)
smooths <- data.frame(Variable = plotdata$meta$x,
                      x=plotdata$fit[[plotdata$meta$x]],
                      smooth=plotdata$fit$visregFit,
                      lower=plotdata$fit$visregLwr,
                      upper=plotdata$fit$visregUpr)
predicts <- data.frame(Variable = "dim1",
                       x=plotdata$res$CAI_SS_Total,
                       y=plotdata$res$visregRes)

Color<- "#B22222"
p_text <- "p == 0.05"

Scatterplot<-ggplot() +
  geom_point(data = predicts, aes(x, y, colour = x), alpha= 1) +
  scale_colour_gradientn(colours = Color,  name = "") +
  geom_line(data = smooths, aes(x = x, y = smooth), colour = Color,size=4.5) +
  geom_line(data = smooths, aes(x = x, y=lower), linetype="dashed", colour = Color, alpha = 0.9, size = 2.5) +
  geom_line(data = smooths, aes(x = x, y=upper), linetype="dashed",colour = Color, alpha = 0.9, size = 2.5) +
  annotate("text",x = -Inf, y = Inf, hjust = -0.1,vjust = 1,label = p_text, parse=TRUE,size = 8, colour = "black",fontface ="italic" ) +
  theme(legend.position = "none") +
  labs(x = "", y = "") +
  theme(axis.title=element_text(size=26,face="bold"), axis.text=element_text(size=14), axis.title.x=element_text(color = "black"), axis.title.y=element_text(color = "black"))
  
### Save Scatterplot ###

ggsave(file="/dfs1/som/rao_col/sandbox/jirsaraie/MALTX/figures/ACNP_Poster/ScatterPlot_CAI_CA2.pdf",device = "pdf",width = 12, height = 9, units = c("in"))

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
