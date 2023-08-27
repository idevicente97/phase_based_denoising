#$ -S /bin/bash
#$ -cwd
#$ -m be
#$ -M idevicente@bcbl.eu

if [[ -z "${PRJDIR}" ]]; then
  if [[ ! -z "$1" ]]; then
     PRJDIR=$1
  else
     echo -e "\e[31m++ ERROR: You need to input PROJECT DIRECTORY (PRJDIR) as ENVIRONMENT VARIABLE or $1. Exiting!! ...\e[39m"
     exit
  fi
fi

if [[ -z "${ROIDIR}" ]]; then
  if [[ ! -z "$2" ]]; then
     PRJDIR=$2
  else
     echo -e "\e[31m++ ERROR: You need to input PROJECT DIRECTORY (PRJDIR) as ENVIRONMENT VARIABLE or $2. Exiting!! ...\e[39m"
     exit
  fi
fi

list_subjects=(my_subject_list) # change for your list of subjects (e.g. list_subjects=('SUBJ01' 'SUBJ02' ...))

for ROI in lh_Broca rh_Broca lh_Wernicke rh_Wernicke; do	
   
   # Removing ROI files if they exist
   if [ -f "${ROIDIR}/*.${ROI}_ave.txt" ] ; then
      rm "${ROIDIR}/*.${ROI}_ave.txt"
   fi   

   for SUBJ in ${list_subjects[@]}; do
      3dmaskave -quiet -mask ${ROIDIR}/${ROI}.MNI.nii.gz ${PRJDIR}/PREPROC/${SUBJ}/func/${SUBJ}_RAW_betas+tlrc.HEAD >> ${ROIDIR}/RAW.${ROI}_ave.txt
      3dmaskave -quiet -mask ${ROIDIR}/${ROI}.MNI.nii.gz ${PRJDIR}/PREPROC/${SUBJ}/func/${SUBJ}_OLS_betas+tlrc.HEAD >> ${ROIDIR}/OLS.${ROI}_ave.txt
      3dmaskave -quiet -mask ${ROIDIR}/${ROI}.MNI.nii.gz ${PRJDIR}/PREPROC/${SUBJ}/func/${SUBJ}_ODR_betas+tlrc.HEAD >> ${ROIDIR}/ODR.${ROI}_ave.txt	
      3dmaskave -quiet -mask ${ROIDIR}/${ROI}.MNI.nii.gz ${PRJDIR}/PREPROC/${SUBJ}/func/${SUBJ}_HighCor_betas+tlrc.HEAD >> ${ROIDIR}/HighCor.${ROI}_ave.txt	
      3dmaskave -quiet -mask ${ROIDIR}/${ROI}.MNI.nii.gz ${PRJDIR}/PREPROC/${SUBJ}/func/${SUBJ}_tCompCor_betas+tlrc.HEAD >> ${ROIDIR}/tCompCor.${ROI}_ave.txt	
   done

done
