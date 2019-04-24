#!/bin/sh
###################################################################################################
##########################            MALTX - ASHS Processing            ##########################
##########################              Robert Jirsaraie                 ##########################
##########################              rjirsara@uci.edu                 ##########################
##########################                 01/11/2019                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################
<<Use

This script is used allign with Turbo Spin Echo Images to the structural T1 weighted image, so they
may be properly alligned before processing the hippocampal subfield data with the ASHS script.

Use
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################

for SUBID in `ls -d1 /dfs3/som/rao_col/maltx/bids/sub* | awk -F\- ' { print $NF }' | grep -v '006x717' | grep -v '008x689'`; do

  echo $SUBID

  if [ -a /dfs3/som/rao_col/maltx/analysis/ashs/${SUBID}/final/${SUBID}_left_lfseg_corr_usegray.nii.gz ]; then
    echo "$SUBID already run through ashs processing..."
  else

sed s/SUBID/${SUBID}/g /dfs3/som/rao_col/maltx/scripts/ashs/process_ashs_template.sh > /dfs3/som/rao_col/maltx/scripts/ashs/qsub_files_ashs/${SUBID}_process_ashs_template.sh

qsub /dfs3/som/rao_col/maltx/scripts/ashs/qsub_files_ashs/${SUBID}_process_ashs_template.sh

chmod ug+wrx /dfs3/som/rao_col/maltx/scripts/ashs/qsub_files_ashs/${SUBID}_process_ashs_template.sh

  fi
done

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################
