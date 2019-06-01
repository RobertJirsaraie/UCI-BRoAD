#!/usr/bin/env Rscript
###################################################################################################
##########################            MALTX - Pull RedCap Data           ##########################
##########################              Robert Jirsaraie                 ##########################
##########################              rjirsara@uci.edu                 ##########################
##########################                  05/07/2019                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

##########################################
### Load Packages and Variables Needed ###
##########################################

library(RCurl)
library(jsonlite)
source('~/.datapullrc.R')

#######################################
### Pull Data From the Child Report ###
#######################################

RAW_child <- postForm(
  uri='https://ci-redcap.hs.uci.edu/api/',
  token=MALTX_TOKEN,
  content='report',
  format='json',
  report_id='2230',
  rawOrLabel='raw',
  rawOrLabelHeaders='raw',
  exportCheckboxLabel='false',
  returnFormat='json'
)

JSON_child <- fromJSON(RAW_child)
JSON_child <- lapply(JSON_child, function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})

CHILD <- as.data.frame(JSON_child)
CHILD$redcap_repeat_instance<-NULL
CHILD$redcap_repeat_instrument<-NULL
names(CHILD)[2]<-"redcap_event_CHILD"

### Define Variable Classes ###

maxcol_CHILD<-dim(CHILD)[2]
CHILD[,3:maxcol_CHILD] = apply(CHILD[,3:maxcol_CHILD], 2, function(x) as.numeric(as.character(x)))
CHILD$child_substance_abuse<-as.factor(CHILD$child_substance_abuse)

########################################
### Pull Data From the Parent Report ###
########################################

RAW_parent <- postForm(
  uri='https://ci-redcap.hs.uci.edu/api/',
  token=MALTX_TOKEN,
  content='report',
  format='json',
  report_id='2224',
  rawOrLabel='raw',
  rawOrLabelHeaders='raw',
  exportCheckboxLabel='false',
  returnFormat='json'
)

JSON_parent <- fromJSON(RAW_parent)
JSON_parent <- lapply(JSON_parent, function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})

PARENT <- as.data.frame(JSON_parent)
PARENT$redcap_event_name
PARENT$redcap_repeat_instance<-NULL
PARENT$redcap_repeat_instrument<-NULL
PARENT$demo_rpt_date<-NULL
names(PARENT)[2]<-"redcap_event_PARENT"

### Define Variable Classes ###

min<-which(names(PARENT)=='sleep_score')
max<-which(names(PARENT)=='psychosis_score')
PARENT[,min:max] = apply(PARENT[,min:max], 2, function(x) as.numeric(as.character(x)))
min<-which(names(PARENT)=='brief_p_inhib_t')
max<-dim(PARENT)[2]
PARENT[,min:max] = apply(PARENT[,min:max], 2, function(x) as.numeric(as.character(x)))

###########################################################
### Pull the Varible Classifying Participants By Groups ###
###########################################################

RAW_GROUPS <- postForm(
  uri='https://ci-redcap.hs.uci.edu/api/',
  token=MALTX_TOKEN,
  content='report',
  format='json',
  report_id='2286',
  rawOrLabel='raw',
  rawOrLabelHeaders='raw',
  exportCheckboxLabel='false',
  returnFormat='json'
)

JSON_GROUPS <- fromJSON(RAW_GROUPS)
JSON_GROUPS <- lapply(JSON_GROUPS, function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})

GROUPS <- as.data.frame(JSON_GROUPS)
GROUPS$redcap_repeat_instance<-NULL
GROUPS$redcap_repeat_instrument<-NULL
names(GROUPS)[2]<-"redcap_event_GROUPS"
names(GROUPS)[3]<-"Enrollment_Group_ALL"

GROUPS$Enrollment_Group_NC_MDD_MALTXMDD<-as.numeric(GROUPS$Enrollment_Group_ALL)
GROUPS$Enrollment_Group_NC_MDD_MALTXMDD[GROUPS$Enrollment_Group_NC_MDD_MALTXMDD == '3'] <- NA
GROUPS$Enrollment_Group_NC_MDD_MALTXMDD<-as.factor(GROUPS$Enrollment_Group_NC_MDD_MALTXMDD)

GROUPS$Enrollment_Group_NC_MDD<-as.numeric(GROUPS$Enrollment_Group_ALL)
GROUPS$Enrollment_Group_NC_MDD[GROUPS$Enrollment_Group_NC_MDD == '3'] <- NA
GROUPS$Enrollment_Group_NC_MDD[GROUPS$Enrollment_Group_NC_MDD == '4'] <- NA
GROUPS$Enrollment_Group_NC_MDD<-as.factor(GROUPS$Enrollment_Group_NC_MDD)

GROUPS$Enrollment_Group_noMDDvsMDD<-as.numeric(GROUPS$Enrollment_Group_ALL)
GROUPS$Enrollment_Group_noMDDvsMDD[GROUPS$Enrollment_Group_noMDDvsMDD == '3'] <- 1
GROUPS$Enrollment_Group_noMDDvsMDD[GROUPS$Enrollment_Group_noMDDvsMDD == '4'] <- 2
GROUPS$Enrollment_Group_noMDDvsMDD<-as.factor(GROUPS$Enrollment_Group_noMDDvsMDD)

GROUPS$Enrollment_Group_noMALTXvsMALTX<-as.numeric(GROUPS$Enrollment_Group_ALL)
GROUPS$Enrollment_Group_noMALTXvsMALTX[GROUPS$Enrollment_Group_noMALTXvsMALTX == '2'] <- 1
GROUPS$Enrollment_Group_noMALTXvsMALTX[GROUPS$Enrollment_Group_noMALTXvsMALTX== '4'] <- 3
GROUPS$Enrollment_Group_noMALTXvsMALTX<-as.factor(GROUPS$Enrollment_Group_noMALTXvsMALTX)

#####################################
### Pull Data From the Interviews ###
#####################################

RAW_interview <- postForm(
  uri='https://ci-redcap.hs.uci.edu/api/',
  token=MALTX_TOKEN,
  content='report',
  format='json',
  report_id='2014',
  rawOrLabel='raw',
  rawOrLabelHeaders='raw',
  exportCheckboxLabel='false',
  returnFormat='json'
)

JSON_interview <- fromJSON(RAW_interview)
JSON_interview <- lapply(JSON_interview, function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})

INTERVIEW <- as.data.frame(JSON_interview)
INTERVIEW$redcap_repeat_instance<-NULL
INTERVIEW$redcap_repeat_instrument<-NULL
names(INTERVIEW)[2]<-"redcap_event_INTERVIEW"

###############################################
### Pull the Data From the NeuroPsych Tests ###
###############################################

RAW_neuropsych <- postForm(
  uri='https://ci-redcap.hs.uci.edu/api/',
  token=MALTX_TOKEN,
  content='report',
  format='json',
  report_id='2252',
  rawOrLabel='raw',
  rawOrLabelHeaders='raw',
  exportCheckboxLabel='false',
  returnFormat='json'
)

JSON_neuropsych <- fromJSON(RAW_neuropsych)
JSON_neuropsych <- lapply(JSON_neuropsych, function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})

NEUROPSYCH <- as.data.frame(JSON_neuropsych)
NEUROPSYCH$redcap_repeat_instance<-NULL
NEUROPSYCH$redcap_repeat_instrument<-NULL
names(NEUROPSYCH)[2]<-"redcap_event_NEUROPSYCH"

max<-dim(NEUROPSYCH)[2]
NEUROPSYCH[,3:max] = apply(NEUROPSYCH[,3:max], 2, function(x) as.numeric(as.character(x)))

#################################################################
### Merge the Files Together and Export the Final Spreadsheet ###
#################################################################

data<-merge(PARENT, CHILD, by=c('record_id'),all=FALSE)
data<-merge(data, GROUPS, by=c('record_id'),all=FALSE)
data<-merge(data, INTERVIEW, by=c('record_id'),all=FALSE)
NEUROPSYCH<-NEUROPSYCH[which(NEUROPSYCH$record_id %in% data$record_id),]
data<-merge(data, NEUROPSYCH, by=c('record_id'),all=TRUE)
names(data)[1]<-'SUBID'
data$SUBID<-as.numeric(as.character(data$SUBID))
data<-data[order(data$SUBID),]
data$INCLUSION_ALL<-1

data$INCLUSION_PR_20190614<-0
maxcol<-ncol(data)
data[1:82,maxcol]<-1

data$INCLUSION_PR_MatchedGroups<-0
csv<-read.csv("/dfs3/som/rao_col/maltx/datasets/redcap/Match_15_Controls_MDD_MDD+MALTX.csv")
matchedsubs<-which(data$SUBID %in% csv$record_id)
maxcol<-ncol(data)
data[matchedsubs,maxcol]<-1

Date<-format(Sys.time(), "%Y%m%d")
Subs<-nrow(data)

file<-print(paste0("/dfs3/som/rao_col/maltx/datasets/redcap/n",Subs,"_Demo+Clinical+Neuropsych_",Date,".rds"))
saveRDS(data, file)
Sys.chmod(file, "774", use_umask = FALSE)

file<-print(paste0("/dfs3/som/rao_col/maltx/datasets/redcap/n",Subs,"_Demo+Clinical+Neuropsych_",Date,".csv"))
write.csv(data, file)
Sys.chmod(file, "774", use_umask = FALSE)

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
