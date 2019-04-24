#!/bin/sh
###################################################################################################
##########################        MALTX - Freesurfer Processing          ##########################
##########################              Robert Jirsaraie                 ##########################
##########################              rjirsara@uci.edu                 ##########################
##########################                 01/11/2019                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################

for SUBID in `ls -d1 /dfs3/som/rao_col/maltx/bids/sub* | awk -F\- ' { print $NF } '`; do
  echo $SUBID
  if [ -a /dfs3/som/rao_col/maltx/analysis/freesurfer/${SUBID}/stats/aseg.stats ]; then
    echo "$SUBID already ran through freesurfer processing..."
  else

sed s/SUBID/${SUBID}/g /dfs3/som/rao_col/maltx/scripts/freesurfer/process_freesurfer_template.sh > /dfs3/som/rao_col/maltx/scripts/freesurfer/freesurfer_qsub_files/${SUBID}_process_freesurfer.sh

qsub /dfs3/som/rao_col/maltx/scripts/freesurfer/freesurfer_qsub_files/${SUBID}_process_freesurfer.sh

chmod ug+wrx /dfs3/som/rao_col/maltx/scripts/freesurfer/freesurfer_qsub_files/${SUBID}_process_freesurfer.sh 

  fi
done

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################
