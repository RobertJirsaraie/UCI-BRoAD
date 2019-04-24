#!/bin/sh
###################################################################################################
##########################           MALTX Manual Struct QA              ##########################
##########################              Robert Jirsaraie                 ##########################
##########################             rjirsara@upenn.edu                ##########################
##########################                  02/28/2019                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

########################################################
### Set default variables, primarly infile & outfile ###
########################################################

subjects=`echo /dfs3/som/rao_col/maltx/analysis/ashs/*`

outfile=/dfs3/som/rao_col/maltx/scripts/ashs/quality_ratings_registration/manualQA_registration.csv

echo "SubID,Seg_QA_Rating" >> $outfile

for i in ${subjects} ; do
      
        subid=`echo ${i} | cut -d '/' -f8`
	segmentation=`echo ${i}/final/*_left_lfseg_corr_usegray.nii.gz`

	echo $subid
	echo $segmentation

	echo "*********"$subid"*********"$subid"*********"$subid"*********"

/dfs3/som/rao_col/bin/itksnap/itksnap-3.4.0-20151130-Linux-x86_64/bin/itksnap -g ${i}/tse.nii.gz -s ${segmentation}
	echo "Enter your Rating Options are: 1-Missing, 2-Invalid, 3-Questionable, 4-Great,"
	select rating in \
          "Missing" \
	  "Invalid" \
          "Questionable" \
          "Great"
          do
            case "${REPLY}" in
	      1) rating=NA
                 break
                 ;;
              2) rating=0
                 break
                 ;;
              3) rating=1
                 break
                 ;;
              4) rating=2
                 break
                 ;;
              *) echo "Invalid option"
                 ;;
            esac
        done
	echo $subid,$rating >> $outfile
        echo 'Saving your rating for '${subid}
done

chmod ug+wrx $outfile

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
