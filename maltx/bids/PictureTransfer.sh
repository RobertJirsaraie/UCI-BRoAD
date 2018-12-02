#!/bin/bash
###################################################################################################
##########################           MALTX - Generate Pictures           ##########################
##########################              Robert Jirsaraie                 ##########################
##########################              rjirsara@uci.edu                 ##########################
##########################                  11/03/2018                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
<<USE

This script Generates Screenshots of Participants Structural Images so they can be sent 
through email.

USE
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

#############################################################################
### Find the Newly Scanned Subjects to Generate Pictures for Participants ###
#############################################################################

ls /dfs1/som/rao_col/maltx/bids | cut -d '-' -f2 > xnatsubjects_pics.txt

existing=`echo /dfs1/som/rao_col/maltx/dicoms/*/*/pics/*.gif` 

for e in $existing ; do

echo $e | cut -d '/' -f7 | sed s@'_'@'x'@g >> hpcsubjects_pics.txt

done

newsubjects=`diff hpcsubjects_pics.txt xnatsubjects_pics.txt | grep x | sed s@'> '@''@g`

rm *subjects* 

##########################################
### Generate Pictures for Participants ###
##########################################

for n in $newsubjects ; do

SubjectID=`echo $n | cut -d 'x' -f1`
ValidateID=`echo $n | cut -d 'x' -f2`

path=/dfs1/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/pics
mkdir $path

options='_run-02_ _'

for o in $options ; do

slices /dfs1/som/rao_col/maltx/bids/sub-${SubjectID}x${ValidateID}/ses-1/anat/sub-${SubjectID}x${ValidateID}_ses-1${o}T1w.nii.gz -u -o ${path}/T1w_Multi.gif

slicer /dfs1/som/rao_col/maltx/bids/sub-${SubjectID}x${ValidateID}/ses-1/anat/sub-${SubjectID}x${ValidateID}_ses-1${o}T1w.nii.gz -u -x 0.5 ${path}/T1w_NoFilter.png

slicer /dfs1/som/rao_col/maltx/bids/sub-${SubjectID}x${ValidateID}/ses-1/anat/sub-${SubjectID}x${ValidateID}_ses-1${o}T1w.nii.gz -l render1 -u -x 0.5 ${path}/T1w_Render1.png

slicer /dfs1/som/rao_col/maltx/bids/sub-${SubjectID}x${ValidateID}/ses-1/anat/sub-${SubjectID}x${ValidateID}_ses-1${o}T1w.nii.gz -l striatum-con-7sub -u -x 0.5 ${path}/T1w_Colored.png

slicer /dfs1/som/rao_col/maltx/bids/sub-${SubjectID}x${ValidateID}/ses-1/anat/sub-${SubjectID}x${ValidateID}_ses-1${o}T2w.nii.gz -u -z 0.5 ${path}/T2w_NoFilter.png

slicer /dfs1/som/rao_col/maltx/bids/sub-${SubjectID}x${ValidateID}/ses-1/anat/sub-${SubjectID}x${ValidateID}_ses-1_acq-TSEcor${o}T2w.nii.gz -u -z 0.5 ${path}/TSEw_NoFilter.png

done

###########################################################
### Adjust the Permission for the Newly Generated Files ###
###########################################################

chmod -R ug+rwx /dfs1/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/pics

#################################################################
### Make Log File if the Pictures were not Generated Properly ###
#################################################################

TODAY=`date "+%Y%m%d"`

if [ ! -f /dfs1/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/pics/*.gif ]; then

echo 'This Subject did not have their Pictures Generated Properly as of this date:' $TODAY 'Check on Xnat and with Robert to troubleshoot the issue!' > /dfs1/som/rao_col/maltx/scripts/bids/logs/${SubjectID}x${ValidateID}_MissingPics.txt
rm -rf /dfs1/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/pics

echo 'LOVE'

	else

rm /dfs1/som/rao_col/maltx/scripts/bids/logs/${SubjectID}x${ValidateID}_MissingPics.txt
echo 'HATE'
fi

chmod ug+rwx /dfs1/som/rao_col/maltx/scripts/bids/logs/*

done

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
