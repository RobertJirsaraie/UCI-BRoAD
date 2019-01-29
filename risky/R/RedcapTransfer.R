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

maxcol_demo<-dim(df_demo)[2]
df_demo[,c(1,maxcol_demo)] <- lapply(df_demo[,c(1,maxcol_demo)], as.numeric)
df_demo$redcap_repeat_instance<-NULL
df_demo$redcap_repeat_instrument<-NULL
df_demo$redcap_event_name<-NULL
df_demo$sex<-as.factor(df_demo$sex)

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

maxcol_clinical<-dim(df_clinical)[2]
df_clinical[,c(1,maxcol_clinical)] <- lapply(df_clinical[,c(1,maxcol_clinical)], as.numeric)
df_clinical$redcap_repeat_instance<-NULL
df_clinical$redcap_repeat_instrument<-NULL
df_clinical$redcap_event_name<-NULL
df_clinical$Exclusions<-1

#################################################################
### Merge the Files Together and Export the Final Spreadsheet ###
#################################################################

data<-merge(df_demo, df_clinical, by=c('record_id'))

Date<-format(Sys.time(), "%Y%m%d")
Subs<-nrow(data)

file<-print(paste0("/dfs3/som/rao_col/risky/datasets/R/n",Subs,"_Demo+MDD+MAL_",Date,".rds"))
saveRDS(data, file)
Sys.chmod(file, "775", use_umask = FALSE)

file<-print(paste0("/dfs3/som/rao_col/risky/datasets/R/n",Subs,"_Demo+MDD+MAL_",Date,".csv"))
write.csv(data, file)
Sys.chmod(file, "775", use_umask = FALSE)

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
