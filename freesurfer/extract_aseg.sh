#!/bin/sh
###################################################################################################
##########################          MALTX - Extract ASEG Data            ##########################
##########################               Robert Jirsaraie                ##########################
##########################               rjirsara@uci.edu                ##########################
##########################                 11/06/2018                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

###################################################################
##### Define the Subjects-Level Directories & the Output Path #####
###################################################################

subjects=`ls /dfs1/som/rao_col/maltx/analysis/freesurfer/* | grep [0-9][0-9][0-9]x | sed s@':'@''@g`
outdir=/dfs1/som/rao_col/maltx/datasets/neuroimaging
rm ${outdir}/*FreeSurf_ASEG_Vol*.csv

########################################################
##### Extract the ASEG Values and Save Output File #####
########################################################

module load freesurfer/6.0

asegstats2table --subjects $subjects --all-segs --skip --meas volume --tablefile ASEG_temp1.txt

#######################################################
##### Prepare the Output File to be Analyzed in R #####
#######################################################

cat ASEG_temp1.txt | tr "\t" "," | sed s/"Measure:volume"/SUBIDxValidateID/g | sed s@"/dfs1/som/rao_col/maltx/analysis/freesurfer/"@""@g > ASEG_temp2.txt

################################################################
##### Remove the 0's and Validation ID in the SUBID Column #####
################################################################

cat ASEG_temp2.txt |cut -d ',' -f1 | cut -d 'x' -f1 >> subs_temp1.csv
subs=`sed 's/^0*\([^,]\)/\1/;s/,0*\([^,]\)/,\1/g' subs_temp1.csv` 
echo $subs|tr " " "\n"  >> subs_temp2.csv
sed "s/$/,/g" subs_temp2.csv >> data_temp1.csv

data=`cut -d ',' -f1 --complement ASEG_temp2.txt`
echo $data | tr " " "\n" >> data_temp2.csv

######################################
##### Save the Final Output File #####
######################################

TODAY=`date "+%Y%m%d"`
dim=`echo $subs | wc -w`
((count = dim - 1))

paste --delimiters='' data_temp1.csv data_temp2.csv >> ${outdir}/n${count}_FreeSurf_ASEG_Vol_${TODAY}.csv

####################################################
##### Change Permissions and Delete Temp Files #####
####################################################

rm *temp*.txt
rm *temp*.csv
chmod ug+rwx ${outdir}/n${count}_FreeSurf_ASEG_Vol_${TODAY}.csv

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
