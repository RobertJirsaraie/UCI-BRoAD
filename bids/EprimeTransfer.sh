#!/bin/bash
###################################################################################################
##########################          MALTX - Eprime Tranfer Data          ##########################
##########################              Robert Jirsaraie                 ##########################
##########################              rjirsara@uci.edu                 ##########################
##########################                  08/17/2018                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
<<Use

This script is used to donwload subjects from Xnat and upload them to the HPC cluster. The dicoms are then
converted to Niftis using BIDs. The Nifits files are then moved to their respective directories.

Use
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

#########################################################################
### Find the Newly Scanned Subjects that Need to Be Downloaded to HPC ###
#########################################################################

ls /dfs3/som/rao_col/maltx/dicoms/*_*/3440_*_1/eprime/ForbesRewardv1-*-1-ExperimentAdvisorReport.xml | cut -d '/' -f7 | cut -d '_' -f1 > hpcsubjects_eprime.txt

wget http://128.200.77.154/data/experiments/ 

cat index.html | sed 's@","@\n@g' | grep label | grep -v pilot | grep 3440 | cut -d '_' -f2 > xnatsubjects_eprime.txt

sort -t _ -k 1 -g xnatsubjects_eprime.txt > xnatsubjects_eprime_sorted.txt

newsubjects=`diff hpcsubjects_eprime.txt xnatsubjects_eprime_sorted.txt | grep -v a | sed s@'> '@''@g`

rm *subjects* index.html

#####################################
### Call To Download E-Prime Data ###
#####################################

for n in $newsubjects ; do

SubjectID=`echo ${n}`
ValidateID=`echo /dfs3/som/rao_col/maltx/dicoms/${SubjectID}* | cut -d '_' -f3`
output='/dfs3/som/rao_col/maltx/dicoms'

wget http://128.200.77.154/data/experiments/ 
URI=`cat ./index.html | sed 's/"label"/\n/g' | grep 3440_${SubjectID}_1 | cut -d '"' -f6`
rm ./index.html

wget http://128.200.77.154${URI}/resources/
XnatID=`cat ./index.html | sed 's/","/\n/g' | grep xnat_abstractresource_id | cut -d '"' -f3`
rm ./index.html

wget http://128.200.77.154${URI}/resources/${XnatID}/files/3440_${SubjectID}.pdf?format=zip -O ${output}/${SubjectID}_${ValidateID}_eprime.zip

#############################################################
### Clean the Downloaded Directory and Update Permissions ###
#############################################################

output='/dfs3/som/rao_col/maltx/dicoms'
unzip ${output}/${SubjectID}_${ValidateID}_eprime.zip -d ${output}/${SubjectID}_${ValidateID}/
rm -rf ${output}/${SubjectID}_${ValidateID}_eprime.zip

#################################
### Organize the E-PRIME Data ###
#################################

path=/dfs3/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/eprime
mkdir $path
old=/dfs3/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/resources/Behav/*prime 
new=`/dfs3/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/resources/Behav/*prime | sed s@'-'@@'_'g`

mv $old $new

date=`ls /dfs3/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/resources/Behav/files/ | grep prime | sed s@-@_@g | cut -d '_' -f3`

cp /dfs3/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/resources/Behav/files/*.PDF ${path}/${date}_Notes.pdf
cp /dfs3/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/resources/Behav/files/*.pdf ${path}/${date}_Notes.pdf
cp /dfs3/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/resources/Behav/files/3440*${SubjectID}*eprime/* ${path}/

rm -rf /dfs3/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/resources

##########################################################
### Adjust the Permission for the New Downloaded Files ###
##########################################################

chmod -R ug+rwx /dfs3/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/eprime

###############################################################
### Make Log File if E-PRIME Data was not Uploaded Properly ###
###############################################################

TODAY=`date "+%Y%m%d"`

if [ ! -f /dfs3/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/eprime/ForbesRewardv1-*-1-ExperimentAdvisorReport.xml ]; then

echo 'This Subject did not have their Niftis Uploaded Properly as of this date:' $TODAY 'Check on Xnat and with Derek to troubleshoot the issue!' >/dfs3/som/rao_col/maltx/scripts/bids/logs/Subs_MissingEprimeUpload/${SubjectID}x${ValidateID}_MissingEPRIME.txt

	else

rm /dfs3/som/rao_col/maltx/scripts/bids/logs/Subs_MissingEprimeUpload/${SubjectID}x${ValidateID}_MissingEPRIME.txt

fi

chmod ug+rwx /dfs3/som/rao_col/maltx/scripts/bids/logs/*

done
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
