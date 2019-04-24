#!/bin/bash
#$ -N ASHS_SUBID
#$ -q gpu1080,ionode
#$ -ckpt blcr
#$ -l kernel=blcr
#$ -r y
#$ -m e
#$ -cwd
#$ -notify
###########################################
### Load Software and Define Root Paths ###
###########################################

module load python/2.7.15
module load ants/2.2.0-118
module load enthought_python/7.3.2
module load afni/v19.0.01

ATLAS=/dfs3/som/rao_col/bin/ashs_atlas_upennpmc_20161128
export ASHS_ROOT=/dfs3/som/rao_col/bin/ashs-fastashs

############################
### Define the Raw Scans ###
############################

T1w_raw=`find /dfs3/som/rao_col/maltx/bids/sub-SUBID/ses-1/anat -name "sub-SUBID_ses-1_T1w.nii.gz"`
tse_raw=`find /dfs3/som/rao_col/maltx/bids/sub-SUBID/ses-1/anat -name "sub-SUBID_ses-1_acq-TSEcor_T2w.nii.gz"`

###############################
### Define the Output Paths ###
###############################

ashs_output=`echo '/dfs3/som/rao_col/maltx/analysis/ashs/SUBID'`
rm -rf ${ashs_output}
mkdir -p ${ashs_output}

###############################################################
### Process the Newly Registered Scans with the ASHS Script ###
###############################################################

opt='1-7'

${ASHS_ROOT}/bin/ashs_main.sh -I SUBID -a ${ATLAS} -g ${T1w_raw} -f ${tse_raw} -w ${ashs_output} -T -d -s ${opt} > /dfs3/som/rao_col/maltx/scripts/ashs/qsub_files_ashs/logs/SUBID_Tracked 2>&1

##########################################
### Clean Files and Update Permissions ###
##########################################

chmod -R ug+rwx ${ashs_output}

rm /dfs3/som/rao_col/maltx/scripts/ashs/ASHS_SUBID*

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################
