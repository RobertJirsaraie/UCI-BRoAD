#!/bin/bash
#$ -N fs6_SUBID
#$ -q som,asom*,free*,pub*
#$ -ckpt blcr
#$ -l kernel=blcr
#$ -r y
#$ -m e
#$ -cwd
#$ -notify

# Running FS6 to obtain HF sub region volumes
module purge
module load freesurfer/6.0

# 001x1774

if [ -d /dfs1/som/rao_col/maltx/analysis/freesurfer ]; then 
  echo ""
else
 mkdir /dfs1/som/rao_col/maltx/analysis/freesurfer;
fi

export SUBJECTS_DIR=/dfs1/som/rao_col/maltx/analysis/freesurfer

mkdir /dfs1/som/rao_col/maltx/analysis/mgz

#mri_convert /dfs1/som/rao_col/maltx/analysis/3440_007_1/3danat/T1.nii /dfs1/som/rao_col/maltx/analysis/3440_007_1/3danat/T1.mgz
if [ -a /dfs1/som/rao_col/maltx/rawImages/sub-SUBID/ses-1/anat/sub-SUBID_ses-1_T1w.nii.gz ]; then 

	mri_convert /dfs1/som/rao_col/maltx/rawImages/sub-SUBID/ses-1/anat/sub-SUBID_ses-1_T1w.nii.gz /dfs1/som/rao_col/maltx/analysis/mgz/sub-SUBID_ses-1_T1w_converted.mgz
else
		
	mri_convert /dfs1/som/rao_col/maltx/rawImages/sub-SUBID/ses-1/anat/sub-SUBID_ses-1_run-02_T1w.nii.gz /dfs1/som/rao_col/maltx/analysis/mgz/sub-SUBID_ses-1_T1w_converted.mgz
fi

#/data/apps/freesurfer/6b/bin/recon-all-sf -s subid -hippocampalsubfields -no-isrunning
#recon-all -i MGZ -s subid -all -hippocampal-subfields-T1 -brainstem-structures
recon-all -i /dfs1/som/rao_col/maltx/analysis/mgz/sub-SUBID_ses-1_T1w_converted.mgz -s SUBID -all -hippocampal-subfields-T1 -brainstem-structures

