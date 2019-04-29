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
  if [ -a /dfs3/som/rao_col/maltx/analysis/antsct/sub-${SUBID}/sub-${SUBID}_ses-1_T1w_brainvols.csv ]; then
    echo "$SUBID already ran through the AntsCT pipeline..."
  else

sed s/SUBID/${SUBID}/g /dfs3/som/rao_col/maltx/scripts/antsct/process_antsct_template.sh > /dfs3/som/rao_col/maltx/scripts/antsct/qsub_files_antsct/${SUBID}_process_antsct.sh

qsub /dfs3/som/rao_col/maltx/scripts/antsct/qsub_files_antsct/${SUBID}_process_antsct.sh

chmod ug+wrx /dfs3/som/rao_col/maltx/scripts/antsct/qsub_files_antsct/${SUBID}_process_antsct.sh 

  fi
done

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################
