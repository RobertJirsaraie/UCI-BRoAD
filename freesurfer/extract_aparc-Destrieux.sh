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
##### Define the Subjects-Level Directories & the Output Path #####
###################################################################

subjects=`ls /dfs3/som/rao_col/maltx/analysis/freesurfer/* | grep [0-9][0-9][0-9]x | sed s@':'@''@g`
outdir=/dfs3/som/rao_col/maltx/datasets/freesurfer
rm ${outdir}/n*Aparc-Destrieux*.csv

module load freesurfer/6.0

########################################################
##### Extract the ASEG Values and Save Output File #####
########################################################

extractions='lh_meancurv  lh_volume lh_area lh_thickness rh_meancurv rh_volume rh_area rh_thickness'

for e in ${extractions} ; do

hemisphere=`echo $e | cut -d '_' -f1`
property=`echo $e | cut -d '_' -f2`

aparcstats2table --subjects $subjects --skip --hemi ${hemisphere} --parc aparc.a2009s --meas ${property} --tablefile raw1_Aparc-Destrieux_${hemisphere}_${property}.txt

#######################################################
##### Prepare the Output File to be Analyzed in R #####
#######################################################

cat raw1_Aparc-Destrieux_${hemisphere}_${property}.txt | tr "\t" "," | sed s@"lh.aparc.a2009s.${property}"@"SUBIDxValidateID"@g | sed s@"/dfs3/som/rao_col/maltx/analysis/freesurfer/"@""@g > raw2_Aparc-Destrieux_${hemisphere}_${property}.txt

################################################################
##### Remove the 0's and Validation ID in the SUBID Column #####
################################################################

cat raw2_Aparc-Destrieux_${hemisphere}_${property}.txt | cut -d ',' -f1 | cut -d 'x' -f1 > sub1_Aparc-Destrieux_${hemisphere}_${property}.txt
subs=`sed 's/^0*\([^,]\)/\1/;s/,0*\([^,]\)/,\1/g' sub1_Aparc-Destrieux_${hemisphere}_${property}.txt` 
echo $subs|tr " " "\n"  >> sub2_Aparc-Destrieux_${hemisphere}_${property}.txt
sed "s/$/,/g" sub2_Aparc-Destrieux_${hemisphere}_${property}.txt > sub3_Aparc-Destrieux_${hemisphere}_${property}.txt

######################################################
##### Remove the Extra Columns with Missing Data #####
######################################################

data=`cut -d ',' -f1 --complement raw2_Aparc-Destrieux_${hemisphere}_${property}.txt`
echo $data | tr " " "\n" >> raw3_Aparc-Destrieux_${hemisphere}_${property}.txt
#cut -d ',' -f33,35-39 --complement raw2_Aparc-Destrieux_${hemisphere}_${property}.txt > raw3_Aparc-Destrieux_${hemisphere}_${property}.txt #Removes additional Columns if Needed

######################################
##### Save the Final Output File #####
######################################

TODAY=`date "+%Y%m%d"`
dim=`echo $subs | wc -w`
((count = dim - 1))

paste --delimiters='' sub3_Aparc-Destrieux_${hemisphere}_${property}.txt raw3_Aparc-Destrieux_${hemisphere}_${property}.txt > ${outdir}/n${count}_Aparc-Destrieux_${hemisphere}_${property}_${TODAY}.csv

####################################################
##### Change Permissions and Delete Temp Files #####
####################################################

rm raw*_Aparc-Destrieux_${hemisphere}_${property}.txt
rm sub*_Aparc-Destrieux_${hemisphere}_${property}.txt
chmod ug+rwx ${outdir}/n${count}_Aparc-Destrieux_${hemisphere}_${property}_${TODAY}.csv

##############################################
##### Combine Data from both Hemispheres #####
##############################################

files=`ls ${outdir}/n${count}_Aparc-Destrieux_*_${property}_${TODAY}.csv | wc -l`

if [ ${files} == 2 ]; then

echo "Right and Left Hemispheres will be Merged into Single Spreadsheet"

left=${outdir}/n${count}_Aparc-Destrieux_lh_${property}_${TODAY}.csv
right=${outdir}/n${count}_Aparc-Destrieux_rh_${property}_${TODAY}.csv

data=`cut -d ',' -f1 --complement ${right}`
echo $data | tr " " "\n" > RIGHT_HEMISPHERE_${property}.csv


paste --delimiters='' ${left}  RIGHT_HEMISPHERE_${property}.csv > ${outdir}/n${count}_Aparc-Destrieux_${property}_${TODAY}.csv

rm ${left}
rm ${right}
rm RIGHT_HEMISPHERE_${property}.csv

chmod ug+rwx ${outdir}/n${count}_Aparc-Destrieux_${property}_${TODAY}.csv

else

echo "Need Both Hemisphere Before Merging Spreadsheets"

fi
done

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################
