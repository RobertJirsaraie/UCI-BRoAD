###################################################################################################
##########################          MALTX - Dicom Tranfer Images          ##########################
##########################              Robert Jirsaraie                 ##########################
##########################              rjirsara@uci.edu                 ##########################
##########################                  11/27/2018                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
<<Use

This script is used to donwload subjects from Xnat and upload them to the HPC cluster. The dicoms are then
converted to Niftis using BIDs. The Nifits files are then moved to their respective directories.

Use
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

#########################################################################
### Find the Newly Scanned Subjects that Need to Be Downloaded to HPC ###
#########################################################################

ls -d /dfs1/som/rao_col/maltx/bids/*/ | cut -d '-' -f2 | sed s@'/'@''@g > hpcsubjects.txt

wget http://broad-xnat.bic.uci.edu/data/archive/projects/Maltreatment/subjects

cat subjects | sed 's@","@\n@g' | grep label | grep -v pilot | sed s@'-'@'_'@g | cut -d '_' -f2,3 | sed s@'_'@'x'@g > xnatsubjects.txt

sort -t _ -k 1 -g xnatsubjects.txt > xnatsubjects_sorted.txt

newsubjects=`diff hpcsubjects.txt xnatsubjects_sorted.txt | grep x | sed s@'> '@''@g`

rm *subjects*

###################################################
### Download the New Subjects' Dicoms from Xnat ###
###################################################

for s in $newsubjects ; do 

SubjectID=`echo $s | cut -d 'x' -f1`
ValidateID=`echo $s | cut -d 'x' -f2`
output='/dfs1/som/rao_col/maltx/dicoms'

wget http://broad-xnat.bic.uci.edu/data/archive/projects/Maltreatment/subjects/3440_${SubjectID}_${ValidateID}/experiments/3440_${SubjectID}_1/scans/ALL/resources/DICOM/files?format=zip -O ${output}/${SubjectID}_${ValidateID}.zip
unzip ${output}/${SubjectID}_${ValidateID}.zip -d ${output}/${SubjectID}_${ValidateID}/
mv ${output}/${SubjectID}_${ValidateID}.zip ${output}/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/

#####################################################################
### Load the Software to Make Niftis and Start Converting to BIDS ###
#####################################################################

module purge; module load anaconda/2.7-4.3.1
export PATH=$PATH:/dfs1/som/rao_col/bin
mkdir ${output}/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/bids
outputbids=`echo ${output}/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/bids`

dcm2bids -d ${output}/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/scans -p ${SubjectID}x${ValidateID} -s 1 -c /dfs1/som/rao_col/maltx/scripts/bids/config_MALTX.json -o $outputbids --forceDcm2niix --clobber

rm -rf /dfs1/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/scans

###################################################################################################
### Specify the Functional Task Names for BIDS Validation and Fix Inconsistencies in File Names ###
###################################################################################################

FUNCpath=/dfs1/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/bids/sub-${SubjectID}x${ValidateID}/ses-1/func

FuncAll=`echo ${FUNCpath}/*.json`
for f in $FuncAll ; do

cat $f | sed s@'Protocol'@'Task'@g >> ${f}_NEW
mv ${f}_NEW ${f}

cat $f | sed s@'-'@'_'@g >> ${f}_NEW
mv ${f}_NEW ${f}

done

#####################################################
### Move the Nifitis to a Project Level Directory ###
#####################################################

mv /dfs1/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}/3440_${SubjectID}_1/bids/sub-${SubjectID}x${ValidateID} /dfs1/som/rao_col/maltx/bids/

##########################################################
### Adjust the Permission for the New Downloaded Files ###
##########################################################

chmod -R ug+rwx /dfs1/som/rao_col/maltx/dicoms/${SubjectID}_${ValidateID}
chmod -R ug+rwx /dfs1/som/rao_col/maltx/bids/sub-${SubjectID}x${ValidateID}

done

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
