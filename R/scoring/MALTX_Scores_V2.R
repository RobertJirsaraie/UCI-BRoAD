###################################################################################################
##########################          MALTX - Score RedCap Data            ##########################
##########################              Robert Jirsaraie                 ##########################
##########################              rjirsara@uci.edu                 ##########################
##########################                  10/30/2018                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

####################################################################
### Read in Raw Dataset That was Manually Downloaded from RedCap ###
####################################################################

data <- read.csv("/dfs1/som/rao_col/maltx/datasets/clinical/n50_Raw_MALTX_20181202.csv")

##################################
### Score the Demographic Data ###
##################################

Demo<-data[which(complete.cases(data$demographics_and_background_information_v1_complete)==TRUE),]
Demo<-Demo[,c(15,11,18,35)]
colnames(Demo)[1]<-"Age"
Demo$Age<-as.numeric(Demo$Age)
colnames(Demo)[2]<-"Sex"
Demo$Sex<-as.factor(Demo$Sex)
colnames(Demo)[3]<-"Race"
Demo$Race<-as.factor(Demo$Race)
colnames(Demo)[4]<-"Income"
Demo$Income<-as.numeric(Demo$Income)

temp<-data[which(complete.cases(data$demographics_and_background_information_v1_complete)==TRUE),]
Demo<-cbind(temp$record_id,Demo)

######################################################################
### Score the Child Adversity Interview Data - Summary Scores Only ###
######################################################################

CAInterview<-data[which(complete.cases(data$cai_1)==TRUE),]
CAInterview<-CAInterview[,grep("cai", names(CAInterview), value = TRUE)]
CAInterview<-CAInterview[,c(5,9,12,15,18,21,24)]
colnames(CAInterview) <- c("CAI_SS_Seperations","CAI_SS_Illness","CAI_SS_Neglect","CAI_SS_EmoAbu","CAI_SS_PhyAbu","CAI_SS_WitVio","CAI_SS_SexAbu")
CAInterview$CAI_SS_Total<-rowSums(CAInterview[1:7])
CAInterview$CAI_SS_Total<-round(CAInterview$CAI_SS_Total, digits = 1)
CAInterview$CAI_SS_MALTX<-rowSums(CAInterview[c(4,5,7)])
CAInterview$CAI_SS_MALTX<-round(CAInterview$CAI_SS_MALTX, digits =1)

temp<-data[which(complete.cases(data$cai_1)==TRUE),]
CAInterview<-cbind(temp$record_id,CAInterview)

#########################################################
### Create a Group Varible NC=1 MDD=2 MAL=3 MAL/MDD=4 ###
#########################################################

Groups<-data[which(complete.cases(data$enrollment_group)==TRUE),]
Groups<-Groups[,c(1257,1251,1254)]
colnames(Groups)[1]<-"EnrollmentGroups"
Groups$EnrollmentGroups<-as.factor(Groups$EnrollmentGroups)
colnames(Groups)[2]<-"NCvsMDD"
Groups$NCvsMDD<-as.factor(Groups$NCvsMDD)
colnames(Groups)[3]<-"NCvsMAL"
Groups$NCvsMAL<-as.factor(Groups$NCvsMAL)

temp<-data[which(complete.cases(data$enrollment_group)==TRUE),]
Groups<-cbind(temp$record_id,Groups)

###################################################
### Score the Childhood Traumatic Questionnaire ###
###################################################

ChildTrauma<-data[which(complete.cases(data$ctq1)==TRUE),]
ChildTrauma<-ChildTrauma[,grep("ctq", names(ChildTrauma), value = TRUE)]
ChildTrauma<-ChildTrauma[,c(3:30)]
ChildTrauma$ctq2 <- (6-ChildTrauma$ctq2)
ChildTrauma$ctq5 <- (6-ChildTrauma$ctq5)
ChildTrauma$ctq7 <- (6-ChildTrauma$ctq7)
ChildTrauma$ctq10 <- (6-ChildTrauma$ctq10)
ChildTrauma$ctq13 <- (6-ChildTrauma$ctq13)
ChildTrauma$ctq16 <- (6-ChildTrauma$ctq16)
ChildTrauma$ctq22 <- (6-ChildTrauma$ctq22)
ChildTrauma$ctq26 <- (6-ChildTrauma$ctq26)
ChildTrauma$ctq28 <- (6-ChildTrauma$ctq28)
ChildTrauma[2:28] <- lapply(ChildTrauma[2:28], as.numeric)
ChildTrauma$CTQ_SS_Total<-rowSums(ChildTrauma[1:28])
ChildTrauma$CTQ_SS_Categ<-ChildTrauma$CTQ_SS_Total
medianCTQ<-median(ChildTrauma$CTQ_SS_Total, na.rm=TRUE)
ChildTrauma$CTQ_SS_Categ<-ifelse(ChildTrauma$CTQ_SS_Categ < medianCTQ, 1, ifelse(ChildTrauma$CTQ_SS_Categ >= medianCTQ, 2,2))
ChildTrauma$CTQ_SS_Categ<-as.factor(ChildTrauma$CTQ_SS_Categ)
ChildTrauma<-ChildTrauma[,29:30]

temp<-data[which(complete.cases(data$ctq1)==TRUE),]
ChildTrauma<-cbind(temp$record_id,ChildTrauma)

###########################################
### Score the Beck Depression Inventory ###
###########################################

BDI<-data[which(complete.cases(data$bdi1)==TRUE),]
BDI<-BDI[,grep("bdi", names(BDI), value = TRUE)]
BDI<-BDI[,c(3:23)]
BDI$BDI_SS_Total<-rowSums(BDI[c(1:21)])
medianBDI<-median(BDI$BDI_SS_Total, na.rm=TRUE)
BDI$BDI_SS_Categ<-ifelse(BDI$BDI_SS_Total < medianBDI, 1, ifelse(BDI$BDI_SS_Total >= medianBDI, 2,2))
BDI$BDI_SS_Categ<-as.factor(BDI$BDI_SS_Categ)
BDI<-BDI[,22:23]

temp<-data[which(complete.cases(data$bdi1)==TRUE),]
BDI<-cbind(temp$record_id,BDI)

###########################################
### Score the Depression Diagnosis Data ###
###########################################

DSM<-data[which(complete.cases(data$depression_score)==TRUE),]
DSM<-DSM[,grep("depression", names(DSM), value = TRUE)]
DSM$DSM_MDD_Total<-DSM$depression_score
DSM$DSM_MDD_Categ<-ifelse(DSM$DSM_MDD_Total == 0, 1, ifelse(DSM$DSM_MDD_Total > 0, 2,2))
DSM$DSM_MDD_Categ<-as.factor(DSM$DSM_MDD_Categ)
DSM<-DSM[,5:6]

temp<-data[which(complete.cases(data$depression)==TRUE),]
DSM<-cbind(temp$record_id,DSM)

##################################################################
### Merge the Datasets Together to Create a Master Spreadsheet ###
##################################################################

final<-merge(Demo,CAInterview, by=c("temp$record_id"), all =TRUE)
final<-merge(final,ChildTrauma, by=c("temp$record_id"), all =TRUE)
final<-merge(final,BDI, by=c("temp$record_id"), all =TRUE)
final<-merge(final,DSM, by=c("temp$record_id"), all =TRUE)
final<-merge(final,Groups, by=c("temp$record_id"), all =TRUE)
names(final)[1]<-"SUBID"

###################
### Add QA Data ###
###################

final$QA_T1w_Exclude<-1

#############################################
### Save the Final Dataset as an RDS File ###
#############################################

Date<-format(Sys.time(), "%Y%m%d")
Subs<-nrow(final)
file<-print(paste0("/dfs1/som/rao_col/maltx/datasets/clinical/n",Subs,"_Demo+MDD+MAL_",Date,".rds"))

saveRDS(final, file)
Sys.chmod(file, "775", use_umask = FALSE)

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
