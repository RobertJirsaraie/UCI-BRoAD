#!/bin/sh
###################################################################################################
##########################        MALTX - View Freesurfer Output         ##########################
##########################               Robert Jirsaraie                ##########################
##########################               rjirsara@uci.edu                ##########################
##########################                 01/19/2019                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################

#############################################################
##### Define the Subjects of Interest and Load Software #####
#############################################################

free_dir=/dfs1/som/rao_col/maltx/analysis/freesurfer
subjects=`ls $freed_dir | grep [0-9][0-9][0-9]x`

module load freesurfer/6.0

#####################################
##### View the Processed Images #####
#####################################

for s in $subjects ; do

freeview -v \
${free_dir}/${s}/mri/T1.mgz \
${free_dir}/${s}/mri/wm.mgz \
${free_dir}/${s}/mri/brainmask.mgz \
${free_dir}/${s}/mri/aseg.mgz:colormap=lut:opacity=0.2 \
-f ${free_dir}/${s}/surf/lh.white:edgecolor=blue \
${free_dir}/${s}/surf/lh.pial:edgecolor=red \
${free_dir}/${s}/surf/rh.white:edgecolor=blue \
${free_dir}/${s}/surf/rh.pial:edgecolor=red

done

#####################################
##### View the Processed Images #####
#####################################

for s in $subjects ; do

freeview -f  ${free_dir}/${s}/surf/lh.pial:annot=aparc.annot:name=pial_aparc:visible=0 \
${free_dir}/${s}/surf/lh.pial:annot=aparc.a2009s.annot:name=pial_aparc_des:visible=0 \
${free_dir}/${s}/surf/lh.inflated:overlay=lh.thickness:overlay_threshold=0.1,3::name=inflated_thickness:visible=0 \
${free_dir}/${s}/surf/lh.inflated:visible=0 \
${free_dir}/${s}/lh.white:visible=0 \
${free_dir}/${s}/lh.pial \
--viewport 3d

done

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡ #####
###################################################################################################
