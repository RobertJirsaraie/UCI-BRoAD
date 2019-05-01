#!/bin/sh
###################################################################################################
##########################          MALTX - Fmriprep Processing          ##########################
##########################              Robert Jirsaraie                 ##########################
##########################              rjirsara@uci.edu                 ##########################
##########################                 02/19/2019                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################

for SUBID in `ls -d1 /dfs3/som/rao_col/maltx/bids/sub* | awk -F\- ' { print $NF } '`; do
  echo $SUBID
  if [ -a /dfs3/som/rao_col/maltx/fmriprep/sub-${SUBID}.html ]; then
    echo "$SUBID already ran through the fmriprep pipeline..."
  else

sed s/SUBID/${SUBID}/g /dfs3/som/rao_col/maltx/scripts/fmriprep/process_fmriprep_template.sh > /dfs3/som/rao_col/maltx/scripts/fmriprep/qsub_files_fmriprep/${SUBID}_process_fmriprep.sh

qsub /dfs3/som/rao_col/maltx/scripts/fmriprep/qsub_files_fmriprep/${SUBID}_process_fmriprep.sh

chmod ug+wrx /dfs3/som/rao_col/maltx/scripts/fmriprep/qsub_files_fmriprep/${SUBID}_process_fmriprep.sh 

  fi
done

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################
