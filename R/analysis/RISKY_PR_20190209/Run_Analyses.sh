###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

input=`ls /dfs3/som/rao_col/risky/datasets/freesurfer/*`

for i in $input ; do


name=`echo $ ${i} | cut -d '/' -f8 | cut -d '_' -f2,3,4`

cat /dfs3/som/rao_col/risky/scripts/R/analyses/ProgressReport_20190209/Analyze_Template_TP1.R | sed s@"/dfs3/som/rao_col/risky/datasets/redcap/INPUT"@${i}@g > /dfs3/som/rao_col/risky/scripts/R/analyses/ProgressReport_20190209/Age+Sex+ARB_Total/Analyze_${name}_TP1.R

Rscript /dfs3/som/rao_col/risky/scripts/R/analyses/ProgressReport_20190209/Age+Sex+ARB_Total/Analyze_${name}_TP1.R

done

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
