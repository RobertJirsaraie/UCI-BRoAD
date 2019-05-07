#!/usr/bin/env Rscript
###################################################################################################
##########################            RISKY - Pull RedCap Data           ##########################
##########################              Robert Jirsaraie                 ##########################
##########################              rjirsara@uci.edu                 ##########################
##########################                  01/28/2019                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

##########################################
### Load Packages and Variables Needed ###
##########################################

library(RCurl)
library(jsonlite)
source('~/.datapullrc.R')

##################################################################
### Pull the Data From Multiple Forms for the Demographic Data ###
##################################################################

result_demo <- postForm(

  uri='https://ci-redcap.hs.uci.edu/api/',

  token=RISKY_TOKEN,

  content='report',

  format='json',

  report_id=1865,

  rawOrLabel='raw',

  rawOrLabelHeaders='raw',

  exportCheckboxLabel='false',

  returnFormat='json'
)

#################################################
### Prepare the Demographic Data for Analysis ###
#################################################

Json_demo <- fromJSON(result_demo)

Json_demo <- lapply(Json_demo, function(x) {

  x[sapply(x, is.null)] <- NA

  unlist(x)

})

df_demo <- as.data.frame(Json_demo)

df_demo$redcap_repeat_instance<-NULL
df_demo$redcap_repeat_instrument<-NULL

###############################################################
### Pull the Data From Multiple Forms for the Clinical Data ###
###############################################################

result_clinical <- postForm(

  uri='https://ci-redcap.hs.uci.edu/api/',

  token=RISKY_TOKEN,

  content='report',

  format='json',

  report_id=1913,

  rawOrLabel='raw',

  rawOrLabelHeaders='raw',

  exportCheckboxLabel='false',

  returnFormat='json'
)

#################################################
### Prepare the Demographic Data for Analysis ###
#################################################

Json_clinical <- fromJSON(result_clinical)

Json_clinical <- lapply(Json_clinical, function(x) {

  x[sapply(x, is.null)] <- NA

  unlist(x)

})

df_clinical <- as.data.frame(Json_clinical)
df_clinical$redcap_repeat_instance<-NULL
df_clinical$redcap_repeat_instrument<-NULL
df_clinical$Exclusions<-1

#################################################################
### Merge the Files Together and Export the Final Spreadsheet ###
#################################################################

data<-merge(df_demo, df_clinical, by=c('record_id'))
names(data)[1]<-'SUBID'
data<-data[order(data$SUBID),]

timepoint<-data$redcap_event_name.y

maxcol_data<-dim(data)[2]
data[,2:maxcol_data] = apply(data[,2:maxcol_data], 2, function(x) as.numeric(as.character(x)))
data$SUBID<-as.numeric(data$SUBID)
data$sex<-as.factor(data$sex)
data$rand_group_assigned<-as.factor(data$rand_group_assigned)
data$redcap_event_name.x<-NULL
data$redcap_event_name.y<-NULL
data<-cbind(data,timepoint)

Date<-format(Sys.time(), "%Y%m%d")
Subs<-nrow(data)

file<-print(paste0("/dfs3/som/rao_col/risky/datasets/redcap/n",Subs,"_Demo+Clinical_Repeated_",Date,".rds"))
saveRDS(data, file)
Sys.chmod(file, "774", use_umask = FALSE)

file<-print(paste0("/dfs3/som/rao_col/risky/datasets/redcap/n",Subs,"_Demo+Clinical_Repeated_",Date,".csv"))
write.csv(data, file)
Sys.chmod(file, "774", use_umask = FALSE)

####################################################################
### Remove Repeated Measures to Save Speadsheet of Baseline Data ###
####################################################################

data_TP1<-data[which(data$timepoint=="visit_1_child_arm_1"),]
Subs<-nrow(data_TP1)

file<-print(paste0("/dfs3/som/rao_col/risky/datasets/redcap/n",Subs,"_Demo+Clinical_TP1_",Date,".rds"))
saveRDS(data_TP1, file)
Sys.chmod(file, "774", use_umask = FALSE)

file<-print(paste0("/dfs3/som/rao_col/risky/datasets/redcap/n",Subs,"_Demo+Clinical_TP1_",Date,".csv"))
write.csv(data_TP1, file)
Sys.chmod(file, "774", use_umask = FALSE)

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
