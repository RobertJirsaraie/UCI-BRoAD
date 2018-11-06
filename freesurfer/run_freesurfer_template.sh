#!/bin/sh

if [ -d freesurfer_qsub_files ]; then
  echo ""
else
  mkdir freesurfer_qsub_files;
fi

curdir=`pwd`

# provide SUBIDs as input
for SUBID in `ls -d1 ../../rawImages/sub* | awk -F\- ' { print $NF } '`; do
  echo $SUBID
  if [ -d ../../analysis/freesurfer/${SUBID} ]; then
    echo "$SUBID already run through freesurfer..."
  else
    sed s/SUBID/${SUBID}/g freesurfer_template.sh > freesurfer_qsub_files/${SUBID}_freesurfer.sh
    cd freesurfer_qsub_files
    echo "qsub ${SUBID}_freesurfer.sh"
    qsub ${SUBID}_freesurfer.sh
    cd $curdir
  fi
done

