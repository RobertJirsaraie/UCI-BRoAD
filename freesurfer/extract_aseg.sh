#!/bin/sh
###################################################################################################
##########################          MALTX - Extract ASEG Data            ##########################
##########################               Robert Jirsaraie                ##########################
##########################               rjirsara@uci.edu                ##########################
##########################                 11/06/2018                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################

###################################################################
##### Define the Subjects-Level Directories & the Output Path #####
###################################################################

subjects=`ls /dfs3/som/rao_col/maltx/analysis/freesurfer/* | grep [0-9][0-9][0-9]x | sed s@':'@''@g`
outdir=/dfs3/som/rao_col/maltx/datasets/freesurfer
rm ${outdir}/*_Aseg_*.csv

module load freesurfer/6.0

########################################################
##### Extract the ASEG Values and Save Output File #####
########################################################

extractions='volume Area_mm2'

for e in ${extractions} ; do

asegstats2table --subjects $subjects --common-segs --skip --meas ${e} --tablefile ${e}_ASEG_temp1.txt

#######################################################
##### Prepare the Output File to be Analyzed in R #####
#######################################################

cat ${e}_ASEG_temp1.txt | tr "\t" "," | sed s/"Measure:${e}"/SUBIDxValidateID/g | sed s@"/dfs3/som/rao_col/maltx/analysis/freesurfer/"@""@g > ${e}_ASEG_temp2.txt

################################################################
##### Remove the 0's and Validation ID in the SUBID Column #####
################################################################

cat ${e}_ASEG_temp2.txt |cut -d ',' -f1 | cut -d 'x' -f1 >> ${e}_subs_temp1.csv
subs=`sed 's/^0*\([^,]\)/\1/;s/,0*\([^,]\)/,\1/g' ${e}_subs_temp1.csv` 
echo $subs|tr " " "\n"  >> ${e}_subs_temp2.csv
sed "s/$/,/g" ${e}_subs_temp2.csv >> ${e}_data_temp1.csv

######################################################
##### Remove the Extra Columns with Missing Data #####
######################################################

data=`cut -d ',' -f1 --complement ${e}_ASEG_temp2.txt`
echo $data | tr " " "\n" >> ${e}_data_temp2.csv
cut -d ',' -f33,35-39 --complement ${e}_data_temp2.csv >> ${e}_data_temp3.csv

######################################
##### Save the Final Output File #####
######################################

TODAY=`date "+%Y%m%d"`
dim=`echo $subs | wc -w`
((count = dim - 1))

paste --delimiters='' ${e}_data_temp1.csv ${e}_data_temp3.csv >> ${outdir}/n${count}_Aseg_${e}_${TODAY}.csv

####################################################
##### Change Permissions and Delete Temp Files #####
####################################################

rm *temp*.txt
rm *temp*.csv
chmod ug+rwx ${outdir}/n${count}_Aseg_${e}_${TODAY}.csv

done

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################
