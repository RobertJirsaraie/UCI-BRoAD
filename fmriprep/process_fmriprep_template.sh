#!/bin/bash
#$ -N FMP_SUBID
#$ -q interactive,ionode,gpu1080
#$ -ckpt blcr
#$ -l h_vmem=6G
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

scripts_path=/dfs3/som/rao_col/maltx/scripts/fmriprep
bids_root_path=/dfs3/som/rao_col/maltx/bids
inter_output=/dfs3/som/rao_col/sandbox/jirsaraie/fmriprep
final_output=/dfs3/som/rao_col/maltx/

#############################################################
### Execute Fmriprep Pipeline using Singularity Container ###
#############################################################

singularity run --cleanenv ${scripts_path}/fmriprep-1.1.2.simg ${bids_root_path} ${final_output} participant --participant_label SUBID --fs-license-file ${scripts_path}/license.txt --fs-no-reconall -w ${inter_output} --force-bbr --stop-on-first-crash --low-mem --verbose > ${scripts_path}/qsub_files_fmriprep/logs/SUBID_Tracked 2>&1

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################
