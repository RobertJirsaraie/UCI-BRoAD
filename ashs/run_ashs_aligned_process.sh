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

for SUBID in `ls -d1 /dfs3/som/rao_col/maltx/analysis/ashs/* | cut -d '/' -f8 | head -12`; do

echo ""
echo "***${SUBID}***${SUBID}***${SUBID}***${SUBID}***${SUBID}***${SUBID}***"


QArating=`cat /dfs3/som/rao_col/maltx/scripts/ashs/quality_ratings_registration/manualQA_registration.csv | grep ${SUBID} | cut -d ',' -f2`

echo ""
echo ${SUBID}' Manual Rating Was ' ${QArating}


  if [ $QArating == 2 ]; then
    

    echo "$SUBID ran through ASHS processing successfully... Skipping Realignment..."
    echo ""

    else

    echo "$SUBID Needs More Processing... Resubmitting Job..."
    echo ""

sed s/SUBID/${SUBID}/g /dfs3/som/rao_col/maltx/scripts/ashs/process_ashs_aligned_template.sh > /dfs3/som/rao_col/maltx/scripts/ashs/qsub_files_ashs/${SUBID}_process_ashs_template.sh

qsub /dfs3/som/rao_col/maltx/scripts/ashs/qsub_files_ashs/${SUBID}_process_ashs_template.sh

chmod ug+wrx /dfs3/som/rao_col/maltx/scripts/ashs/qsub_files_ashs/${SUBID}_process_ashs_template.sh

  fi
done

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################
