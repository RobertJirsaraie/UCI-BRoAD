#!/bin/bash
#$ -N ANTS_SUBID
#$ -q interactive,ionode,gpu1080
#$ -ckpt blcr
#$ -r y
#$ -m e
#$ -cwd
###########################################
### Load Software and Define Root Paths ###
###########################################

module purge
module load singularity/3.0.0

#####################################
### Define Input and Output Paths ###
#####################################

scripts_path=/dfs3/som/rao_col/maltx/scripts/antsct
bids_root_path=/dfs3/som/rao_col/maltx/bids
final_output=/dfs3/som/rao_col/maltx/analysis/antsct

###########################################################
### Execute AntsCT Pipeline using Singularity Container ###
###########################################################

singularity run --cleanenv ${scripts_path}/antsct-2.2.01.simg ${bids_root_path} ${final_output} participant --participant_label SUBID > ${scripts_path}/qsub_files_antsct/logs/SUBID_Tracked 2>&1

chmod -R ug+wrx /dfs3/som/rao_col/maltx/analysis/antsct/sub-SUBID

rm /dfs3/som/rao_col/maltx/scripts/antsct/ANTS_SUBID.e*

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################
