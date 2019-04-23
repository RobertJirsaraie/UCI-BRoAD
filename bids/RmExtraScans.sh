###################################################################################################
##########################           MALTX - Removing Extra Seq          ##########################
##########################               Robert Jirsaraie                ##########################
##########################               rjirsara@uci.edu                ##########################
##########################                  03/06/2019                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

############
### Anat ###
############

subjects=`ls /dfs3/som/rao_col/maltx/bids/sub-*/ses-1/anat/sub-*_run-*_*`

for sub in $subjects ; do

run1=`echo $sub | grep run-01`
run2=`echo $sub | grep run-02`

rm $run1

new=`echo $run2 | sed s@'_run-02_'@'_'@g`

mv $run2 $new

done

############
### Func ###
############

subjects=`ls /dfs3/som/rao_col/maltx/bids/sub-*/ses-1/func/sub-*_run-*_*`

for sub in $subjects ; do

run1=`echo $sub | grep run-01`
run2=`echo $sub | grep run-02`

rm $run1

new=`echo $run2 | sed s@'_run-02_'@'_'@g`

mv $run2 $new

done

###########
### DTI ###
###########

subjects=`ls /dfs3/som/rao_col/maltx/bids/sub-*/ses-1/dwi/sub-*_run-*_*`

for sub in $subjects ; do

run1=`echo $sub | grep run-01`
run2=`echo $sub | grep run-02`
run3=`echo $sub | grep run-03`

rm $run1

new=`echo $run2 | sed s@'_run-02_'@'_'@g`

mv $run2 $new

done

############
### FMAP ###
############

subjects=`ls /dfs3/som/rao_col/maltx/bids/sub-*/ses-1/dwi/sub-*_run-*_*`

for sub in $subjects ; do

run1=`echo $sub | grep run-01`
run2=`echo $sub | grep run-02`
run3=`echo $sub | grep run-03`

new=`echo $run2 | sed s@'_run-02_'@'_'@g`

mv $run2 $new

new=`echo $run3 | sed s@'_run-03_'@'_'@g`

mv $run3 $new

done

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################