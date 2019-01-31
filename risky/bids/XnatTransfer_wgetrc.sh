###################################################################################################
##########################          RISKY - Xnat Tranfer Images          ##########################
##########################              Robert Jirsaraie                 ##########################
##########################              rjirsara@uci.edu                 ##########################
##########################                  08/20/2018                   ##########################
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

#####################################
### Define the Required Variables ###
#####################################

username=`whoami`
output='/dfs1/som/rao_col/risky/dicoms'
SubjectID=$1
ValidateID=$2
Visit=$3
password=$4
Session=${Visit::1}

#########################################
### Call To Download Images from Xnat ###
#########################################

echo 'Now Starting to Download Dicoms From Xnat'

wget http://broad-xnat.bic.uci.edu/data/archive/projects/Risky/subjects/3439_${SubjectID}_${ValidateID}/experiments/3439_${SubjectID}_${Visit}/scans/ALL/resources/DICOM/files?format=zip -O ${output}/${SubjectID}_${ValidateID}_${Visit}.zip

unzip ${output}/${SubjectID}_${ValidateID}_${Visit}.zip -d ${output}/${SubjectID}_${ValidateID}/
mv ${output}/${SubjectID}_${ValidateID}_${Visit}.zip ${output}/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Session}/${SubjectID}_${ValidateID}_${Visit}.zip

echo 'Now Renaming Dicom Directories'
scans=/dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Visit}/scans/*

for s in $scans ; do

mv $s ${s}_Visit-${Visit}

done

##############################################
### Call To Download EPRIME Data from Xnat ###
##############################################

checkdir=/dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Visit}/resources
if [ -d $checkdir ]; then

echo 'Eprime Data has Already Been Downloaded'

else 

echo 'Eprime Data is being Downloaded Now'

wget http://128.200.77.154/data/experiments/
URI=`cat ./index.html | sed 's/"label"/\n/g' | grep 3439_${SubjectID}_${Visit} | cut -d '"' -f6`
rm ./index.html

time='1 2'

for t in $time ; do

TIME=`echo $URI | cut -d ' ' -f${t}`

echo $TIME

wget http://128.200.77.154${TIME}/resources/
XnatID=`cat ./index.html | sed 's/","/\n/g' | grep xnat_abstractresource_id | cut -d '"' -f3`
rm ./index.html
wget http://128.200.77.154${TIME}/resources/${XnatID}/files/3439_${SubjectID}_${Visit}.pdf?format=zip -O ${output}/${SubjectID}_${ValidateID}_${t}_eprime.zip
unzip ${output}/${SubjectID}_${ValidateID}_${t}_eprime.zip -d ${output}/${SubjectID}_${ValidateID}/
rm ${output}/*.zip
done

fi

#################################
### Organize the E-PRIME Data ###
#################################

path=/dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Session}/eprime
mkdir $path

old=/dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Visit}/resources/Behav/files/*eprime* 
new=`echo $old | sed s@'-'@'_'@g`
mv $old $new

date=`ls /dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Visit}/resources/Behav/files/ | grep eprime | sed s@-@_@g | cut -d '_' -f3`

cp /dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Visit}/resources/Behav/files/*.PDF ${path}/${date}_Notes.pdf
cp /dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Visit}/resources/Behav/files/*.pdf ${path}/${date}_Notes.pdf
cp /dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Visit}/resources/Behav/files/3439*${SubjectID}*eprime/* ${path}/
cp /dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Visit}/resources/Behav/files/*/3439*${SubjectID}*eprime/* ${path}/

rm -rf /dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Visit}/resources

#########################################################################
### Check if there are Extra Sessions Visits that Need to be Combined ###
#########################################################################

Num=`echo $Visit | wc -c`
if [ $Num = 2 ] ; then

echo 'This is a Typical Session - Data will be moved to a Single Directory'
### Run BIDS and Move to The Correct ###

mkdir ${output}/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Session}/bids
module purge; module load anaconda/2.7-4.3.1
export PATH=$PATH:/dfs1/som/rao_col/bin
dcm2bids -d ${output}/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Session}/scans -p ${SubjectID}x${ValidateID} -s ${Session} -c /dfs1/som/rao_col/risky/scripts/bids/config_RISKY.json -o ${output}/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Session}/bids --forceDcm2niix --clobber
mkdir /dfs1/som/rao_col/risky/bids/sub-${SubjectID}x${ValidateID}
mv /dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Session}/bids/sub-${SubjectID}x${ValidateID}/ses-${Session} /dfs1/som/rao_col/risky/bids/sub-${SubjectID}x${ValidateID}/
rm -rf ${output}/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Visit}/scans

else

echo 'This is a Extra Session - Data will be Combined'

unzip ${output}/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Session}/${SubjectID}_${ValidateID}_${Session}.zip -d ${output}/${SubjectID}_${ValidateID}/
mv /dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Visit}/scans/* /dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Session}/scans/
rm -rf ${output}/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Session}/bids
module purge; module load anaconda/2.7-4.3.1
export PATH=$PATH:/dfs1/som/rao_col/bin
dcm2bids -d ${output}/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Session}/scans -p ${SubjectID}x${ValidateID} -s ${Session} -c /dfs1/som/rao_col/risky/scripts/bids/config_RISKY.json -o ${output}/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Session}/bids --forceDcm2niix --clobber

mkdir /dfs1/som/rao_col/risky/bids/sub-${SubjectID}x${ValidateID}
rm -rf /dfs1/som/rao_col/risky/bids/sub-${SubjectID}x${ValidateID}/ses-${Session}
mv /dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Session}/bids/sub-${SubjectID}x${ValidateID}/ses-${Session} /dfs1/som/rao_col/risky/bids/sub-${SubjectID}x${ValidateID}/
rm -rf ${output}/${SubjectID}_${ValidateID}/scans

fi

###########################################################################################
### Move the Nifitis to a Project Level Directory and Specify BIDS Validator Task Names ###
###########################################################################################

FUNCpath=/dfs1/som/rao_col/risky/bids/sub-${SubjectID}x${ValidateID}/ses-${Session}/func

FuncAll=`echo ${FUNCpath}/*.json`
for f in $FuncAll ; do

cat $f | sed s@'Protocol'@'Task'@g >> ${f}_NEW
mv ${f}_NEW ${f}

cat $f | sed s@'-'@'_'@g >> ${f}_NEW
mv ${f}_NEW ${f}

done

##########################################################
### Adjust the Permission for the New Downloaded Files ###
##########################################################

Num=`echo $Visit | wc -c`
if [ $Num = 2 ] ; then
echo 'This is a Typical Session - No Changes will be Made'

else

echo 'This is a Extra Session - Extra Directory will be Deleted'
rm -rf /dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${session}/scans
fi

chmod -R ug+rwx /dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}
chmod -R ug+rwx /dfs1/som/rao_col/risky/bids/sub-${SubjectID}x${ValidateID}/*

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
