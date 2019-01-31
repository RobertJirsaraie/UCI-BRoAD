
SubjectID=$1
ValidateID=$2
Visit=$3

path=/dfs1/som/rao_col/risky/dicoms/${SubjectID}_${ValidateID}/3439_${SubjectID}_${Visit}/pics
mkdir $path

options='_run-02_ _'

for o in $options ; do

slices /dfs1/som/rao_col/risky/rawImages/sub-${SubjectID}x${ValidateID}/ses-${Visit}/anat/sub-${SubjectID}x${ValidateID}_ses-${Visit}${o}T1w.nii.gz -u -o ${path}/T1w_Multi.gif

slicer /dfs1/som/rao_col/risky/rawImages/sub-${SubjectID}x${ValidateID}/ses-${Visit}/anat/sub-${SubjectID}x${ValidateID}_ses-${Visit}${o}T1w.nii.gz -u -x 0.5 ${path}/T1w_NoFilter.png

slicer /dfs1/som/rao_col/risky/rawImages/sub-${SubjectID}x${ValidateID}/ses-${Visit}/anat/sub-${SubjectID}x${ValidateID}_ses-${Visit}${o}T1w.nii.gz -l render1 -u -x 0.5 ${path}/T1w_Render1.png

slicer /dfs1/som/rao_col/risky/rawImages/sub-${SubjectID}x${ValidateID}/ses-${Visit}/anat/sub-${SubjectID}x${ValidateID}_ses-${Visit}${o}T1w.nii.gz -l striatum-con-7sub -u -x 0.5 ${path}/T1w_Colored.png

slicer /dfs1/som/rao_col/risky/rawImages/sub-${SubjectID}x${ValidateID}/ses-${Visit}/anat/sub-${SubjectID}x${ValidateID}_ses-${Visit}${o}T2w.nii.gz -u -z 0.5 ${path}/T2w_NoFilter.png

slicer /dfs1/som/rao_col/risky/rawImages/sub-${SubjectID}x${ValidateID}/ses-${Visit}/anat/sub-${SubjectID}x${ValidateID}_ses-${Visit}_acq-TSEcor${o}T2w.nii.gz -u -z 0.5 ${path}/TSEw_NoFilter.png

done
