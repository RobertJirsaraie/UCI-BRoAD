#!/bin/bash
#$ -N fs6_SUBID
#$ -q som,asom*,free*,pub*
#$ -ckpt blcr
#$ -l kernel=blcr
#$ -r y
#$ -m e
#$ -cwd
#$ -notify
###########################################
### Load Software and Define Root Paths ###
###########################################

module purge
module load freesurfer/6.0
export SUBJECTS_DIR=/dfs3/som/rao_col/maltx/analysis/freesurfer

############################################################
### Create MGZ Files If Needed For Freesurfer Processing ###
############################################################

if [ -a /dfs3/som/rao_col/maltx/bids/sub-SUBID/ses-1/anat/sub-SUBID_ses-1_T1w.nii.gz ]; then 

	mri_convert /dfs3/som/rao_col/maltx/bids/sub-SUBID/ses-1/anat/sub-SUBID_ses-1_T1w.nii.gz /dfs3/som/rao_col/maltx/analysis/mgz/sub-SUBID_ses-1_T1w_converted.mgz
else
		
	mri_convert /dfs3/som/rao_col/maltx/bids/sub-SUBID/ses-1/anat/sub-SUBID_ses-1_run-02_T1w.nii.gz /dfs3/som/rao_col/maltx/analysis/mgz/sub-SUBID_ses-1_T1w_converted.mgz
fi

#################################################################
### Define Paths to Subjects' Scans That Need to be Processed ###
#################################################################

recon-all -i /dfs3/som/rao_col/maltx/analysis/mgz/sub-SUBID_ses-1_T1w_converted.mgz -s SUBID -all -qcache -3T -hippocampal-subfields-T1 -brainstem-structures

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################
