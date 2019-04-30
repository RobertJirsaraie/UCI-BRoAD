#!/bin/sh
###################################################################################################
##########################          MALTX - Extract APARC Data            #########################
##########################               Robert Jirsaraie                ##########################
##########################               rjirsara@uci.edu                ##########################
##########################                 01/23/2019                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################

###################################################################
##### Define the Subjects, Output Path, & Remove Outdate File #####
###################################################################

subjects=`ls -d /dfs3/som/rao_col/maltx/analysis/ashs/*/final/*_left_lfseg_corr_usegray.nii.gz | cut -d '/' -f8`
outdir=/dfs3/som/rao_col/maltx/datasets/ashs
rm ${outdir}/n*_ASHS_HippoSubFields_*.csv

##########################################
##### Add the Headers to the Dataset #####
##########################################

left_labels=`cat /dfs3/som/rao_col/maltx/analysis/ashs/001x1774/final/001x1774_left_corr_usegray_volumes.txt | awk ' { print $2"_"$3"," } '`
right_labels=`cat /dfs3/som/rao_col/maltx/analysis/ashs/001x1774/final/001x1774_right_corr_usegray_volumes.txt | awk ' { print $2"_"$3"," } '`

echo SUBID,${left_labels}${right_labels} | sed s/" "/""/g > ASHS.csv

#####################################################################
##### Extract the Hippocampal Subfield Volume From Each Subject #####
#####################################################################

for SUBID in $subjects ; do
  echo $SUBID

  left_file=`ls /dfs3/som/rao_col/maltx/analysis/ashs/${SUBID}/final/${SUBID}_left_corr_usegray_volumes.txt`
  right_file=`ls /dfs3/som/rao_col/maltx/analysis/ashs/${SUBID}/final/${SUBID}_right_corr_usegray_volumes.txt`
 
  left_volumes=`cat /dfs3/som/rao_col/maltx/analysis/ashs/${SUBID}/final/${SUBID}_left_corr_usegray_volumes.txt | awk ' { print $5"," } '`
  right_volumes=`cat /dfs3/som/rao_col/maltx/analysis/ashs/${SUBID}/final/${SUBID}_right_corr_usegray_volumes.txt | awk ' { print $5"," } '`

  echo ${SUBID},${left_volumes}${right_volumes} | sed s/" "/""/g >> ASHS.csv

done

################################################################
##### Remove the 0's and Validation ID in the SUBID Column #####
################################################################

cat ASHS.csv | cut -d ',' -f1 | cut -d 'x' -f1 > ASHS_SUBS1.csv

subs=`sed 's/^0*\([^,]\)/\1/;s/,0*\([^,]\)/,\1/g' ASHS_SUBS1.csv` 
echo $subs | tr " " "\n"  > ASHS_SUBS2.csv
sed "s/$/,/g" ASHS_SUBS2.csv > ASHS_SUBS3.csv

data=`cut -d ',' -f1 --complement ASHS.csv`
echo $data | tr " " "\n" >> ASHS_DATA.csv

######################################
##### Save the Final Output File #####
######################################

TODAY=`date "+%Y%m%d"`
dim=`echo $subs | wc -w`
((count = dim - 1))

paste --delimiters='' ASHS_SUBS3.csv ASHS_DATA.csv > ${outdir}/n${count}_ASHS_HippoSubFields_${TODAY}.csv
chmod ug+wrx ${outdir}/n${count}_ASHS_HippoSubFields_${TODAY}.csv

cp /dfs3/som/rao_col/maltx/scripts/ashs/quality_ratings_registration/manualQA_registration.csv ${outdir}/

rm ASHS.csv ASHS_DATA.csv ASHS_SUBS1.csv ASHS_SUBS2.csv ASHS_SUBS3.csv

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################
