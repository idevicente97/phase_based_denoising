#!/bin/bash
#$ -cwd
#$ -o out.txt
#$ -e err.txt
#$ -m be
#$ -N anatomical
#$ -S /bin/bash


# ****************************************************************************
# Compute anatomical preprocessing after freesurfer recon-all
# ****************************************************************************

if [[ -z "${PRJDIR}" ]]; then
  if [[ ! -z "$1" ]]; then
     PRJDIR=$1
  else
     echo -e "\e[31m++ ERROR: You need to input PROJECT DIRECTORY (PRJDIR) as ENVIRONMENT VARIABLE or $1. Exiting!! ...\e[39m"
     exit
  fi
fi
if [[ -z "${SUBJ}" ]]; then
  if [[ ! -z "$2" ]]; then
     SUBJ=$2
  else
     echo -e "\e[31m++ ERROR: You need to input SUBJECT (SUBJ) as ENVIRONMENT VARIABLE or $2. Exiting!! ...\e[39m"
     exit
  fi
fi
if [[ -z "${SUMADIR}" ]]; then
  if [[ ! -z "$3" ]]; then
     SUMADIR=$3
  else
     echo -e "\e[31m++ ERROR: You need to input ORIGINAL folder with DIRECTORY with FREE as ENVIRONMENT VARIABLE or $3. Exiting!! ...\e[39m"
     exit
  fi
fi

if [[ ${HOSTAME} == *"ipsnode"* ]]; then
    echo "Loading modules"
    module load afni/latest
fi

set -e

TSPACE=MNI
TEMPLATE_BASENAME="MNI152_2009_template"
SESSION="CRANEOFUNCIONAL1"

echo -e "\e[34m +++ =======================================================================\e[39m"
echo -e "\e[34m +++ ----------------> STARTING ANATOMICAL PREPROCESSING <------------------\e[39m"
echo -e "\e[34m +++ =======================================================================\e[39m"

echo "SUMA directory = $SUMADIR"

if [[ ! -d ${PRJDIR}/PREPROC/${SUBJ}/anat ]]; then
    echo "\e[35m ++ Creating ${PRJDIR}/PREPROC/${SUBJ}/anat ...\e[39m"
    mkdir -p ${PRJDIR}/PREPROC/${SUBJ}/anat
else
    echo -e "\e[35m ++ WARNING: ${PRJDIR}/PREPROC/${SUBJ}/anat already exist. Will overwrite results!! ...\e[39m"
fi
cd ${PRJDIR}/PREPROC/${SUBJ}/anat


# linking freesurfer & SUMA volumes to anat folder (i.e. original T1 space at anatomical resolution)
if [[ -f ${SUBJ}_T1.nii.gz ]]; then
  echo -e "\e[35m ++ WARNING: Deleting current T1-w image ...\e[39m"
  rm ${SUBJ}_T1.nii.gz
fi
3dcopy ${SUMADIR}/nu.nii.gz ./${SUBJ}_T1.nii.gz

if [[ -f ${SUBJ}_T1_ns.nii.gz ]]; then
  echo -e "\e[35m ++ WARNING: Deleting current T1-w skull stripped image ...\e[39m"
  rm ${SUBJ}_T1_ns.nii.gz
fi
3dcopy ${SUMADIR}/norm.nii.gz ./${SUBJ}_T1_ns.nii.gz

if [[ -f ${SUBJ}_T1_ns_bc.nii.gz ]]; then
  echo -e "\e[35m ++ WARNING: Deleting current T1-w skull stripped & bias corrected image ...\e[39m"
  rm ${SUBJ}_T1_ns_bc.nii.gz
fi
3dcopy ${SUMADIR}/brain.nii.gz ./${SUBJ}_T1_ns_bc.nii.gz

for DATA_ANAT in aparc.a2009s+aseg aparc.a2009s+aseg_rank lh.ribbon rh.ribbon
do
  if [[ -f ${DATA_ANAT}.nii.gz ]]; then
    echo -e "\e[35m ++ WARNING: Deleting ${DATA_ANAT} parcellation ...\e[39m"
    rm ${DATA_ANAT}.nii.gz
  fi
  3dcopy ${SUMADIR}/${DATA_ANAT}.nii.gz ./
done


echo -e "\e[34m +++ =======================================================================\e[39m"
echo -e "\e[34m +++ ----------------->    CREATE ANATOMICAL MASKS    <---------------------\e[39m"
echo -e "\e[34m +++ =======================================================================\e[39m"
echo -e "\e[32m ++ INFO: Create anatomical mask...\e[39m"
3dmask_tool -overwrite -dilate_input 2 -2 -fill_holes -input ${SUBJ}_T1_ns.nii.gz -prefix ${SUBJ}_T1_mask.nii.gz
echo -e "\e[32m ++ INFO: Create mask of lateral ventricles...\e[39m"
3dcalc -overwrite -a aparc.a2009s+aseg.nii.gz -datum byte -prefix FS_Vent.nii.gz -expr 'amongst(a,4,43)'
echo -e "\e[32m ++ INFO: Create mask of white matter...\e[39m"
3dcalc -overwrite -a aparc.a2009s+aseg.nii.gz -datum byte -prefix FS_WM.nii.gz -expr 'amongst(a,2,7,41,46,251,252,253,254,255)'
echo -e "\e[32m ++ INFO: Create mask of grey matter cerebellum...\e[39m"
3dcalc -overwrite -a aparc.a2009s+aseg.nii.gz -datum byte -prefix FS_Cerebellum.nii.gz -expr 'amongst(a,8,47)'
echo -e "\e[32m ++ INFO: Create mask of left hemisphere based on aseg...\e[39m"
3dcalc -overwrite -a aparc.a2009s+aseg.nii.gz -b lh.ribbon.nii.gz -datum byte \
  -prefix FS_Lh_mask.nii.gz -expr 'bool(b + amongst(a,2,4,5,7,8,9,10,11,12,13,17,18,19,20,26,27,28))'
3dmask_tool -overwrite -fill_holes -dilate_input 2 -2 -input FS_Lh_mask.nii.gz -prefix FS_Lh_mask.nii.gz
echo -e "\e[32m ++ INFO: Create mask of right hemisphere based on aseg...\e[39m"
3dcalc -overwrite -overwrite -a aparc.a2009s+aseg.nii.gz -b rh.ribbon.nii.gz -datum byte \
  -prefix FS_Rh_mask.nii.gz -expr 'bool(b + amongst(a,41,43,44,45,46,47,48,49,50,51,52,53,54,55,56,58,59,60))'
3dmask_tool -overwrite -fill_holes -dilate_input 2 -2 -input FS_Rh_mask.nii.gz -prefix FS_Rh_mask.nii.gz
echo -e "\e[32m ++ INFO: Create mask of subcortical structures...\e[39m"
3dcalc -overwrite -a aparc.a2009s+aseg.nii.gz -datum byte -prefix FS_Subcortical.nii.gz -expr 'amongst(a,9,10,11,12,13,17,18,19,20,26,27,28,48,49,50,51,52,53,54,55,56,58,59,60)'
echo -e "\e[32m ++ INFO: Create mask of GM voxels...\e[39m"
3dcalc -overwrite -a lh.ribbon.nii.gz -b rh.ribbon.nii.gz -c FS_Cerebellum.nii.gz -d FS_Subcortical.nii.gz -expr 'bool(a+b+c+d)' -prefix FS_GM.nii.gz

# need to create hemispheric MASKS

echo -e "\e[34m +++ ==============================================================================\e[39m"
echo -e "\e[34m +++ --> SUPERFICIAL, MIDDLE AND DEEP MASKS OF WM AND CSF in SUBJECT ANAT SPACE <--\e[39m"
echo -e "\e[34m +++ ==============================================================================\e[39m"
#echo -e "\e[32m ++ INFO: Erosion of 2 voxels of ventricles mask  ...\e[39m"
#3dmask_tool -overwrite -input FS_Vent.nii.gz -dilate_input -2 -prefix rm.FS_Vent.erode2.nii.gz
#echo -e "\e[32m ++ INFO: Computing Masks of Superficial and Deep Ventricles  ...\e[39m"
#3dcalc -overwrite -a FS_Vent.nii.gz -b rm.FS_Vent.erode2.nii.gz -expr 'a-b' -prefix FS_Vent_Superficial.nii.gz
#3dcalc -overwrite -a rm.FS_Vent.erode2.nii.gz -expr 'a' -prefix FS_Vent_Deep.nii.gz

echo -e "\e[32m ++ INFO: Erosion of 1 voxels of ventricles mask  ...\e[39m"
3dmask_tool -overwrite -input FS_Vent.nii.gz -dilate_input -1 -prefix rm.FS_Vent.erode1.nii.gz
echo -e "\e[32m ++ INFO: Computing Masks of Superficial and Deep Ventricles  ...\e[39m"
3dcalc -overwrite -a FS_Vent.nii.gz -b rm.FS_Vent.erode1.nii.gz -expr 'a-b' -prefix FS_Vent_Superficial.nii.gz
3dcalc -overwrite -a rm.FS_Vent.erode1.nii.gz -expr 'a' -prefix FS_Vent_Deep.nii.gz

echo -e "\e[32m ++ INFO: Erosion of 2 voxels of WM mask  ...\e[39m"
3dmask_tool -overwrite -input FS_WM.nii.gz -dilate_input -2 -prefix rm.FS_WM.erode2.nii.gz
echo -e "\e[32m ++ INFO: Erosion of 4 voxels of WM mask  ...\e[39m"
3dmask_tool -overwrite -input FS_WM.nii.gz -dilate_input -4 -prefix rm.FS_WM.erode4.nii.gz

echo -e "\e[32m ++ INFO: Computing Masks of Superficial, Middle and Deep WM ...\e[39m"
3dcalc -overwrite -a FS_WM.nii.gz -b rm.FS_WM.erode2.nii.gz -expr 'a-b' -prefix FS_WM_Superficial.nii.gz
3dcalc -overwrite -a rm.FS_WM.erode2.nii.gz -b rm.FS_WM.erode4.nii.gz -expr 'a-b' -prefix FS_WM_Middle.nii.gz
3dcalc -overwrite -a rm.FS_WM.erode4.nii.gz -expr 'a' -prefix FS_WM_Deep.nii.gz


# ANATOMICAL WARPING TO MNI
# =========================
echo -e "\e[34m +++ =======================================================================\e[39m"
echo -e "\e[34m +++ ------------> ANATOMICAL WARPING TO ${TEMPLATE_BASENAME}     <------------------\e[39m"
echo -e "\e[34m +++ =======================================================================\e[39m"
# warp anatomy to standard space (non-linear warp)
echo -e "\e[32m ++ INFO: Warping of Anatomical to ${PRJDIR}/TEMPLATES_ATLAS/${TEMPLATE}...\e[39m"
auto_warp.py -overwrite -base ${PRJDIR}/TEMPLATES_ATLAS/${TEMPLATE_BASENAME}.nii.gz'[0]' -input ${SUBJ}_T1_ns.nii.gz -skull_strip_input no

# move results up out of the awpy directory
# (NL-warped anat, affine warp, NL warp)
# (use typical standard space name for anat)
# (wildcard is a cheap way to go after any .gz)
3dbucket -overwrite -prefix ${SUBJ}_T1_ns.${TSPACE}.nii.gz  awpy/${SUBJ}_T1_ns.aw.nii*
mv -f awpy/anat.un.aff.Xat.1D ./
mv -f awpy/anat.un.aff.qw_WARP.nii ./
gzip anat.un.aff.qw_WARP.nii

echo -e "\e[34m +++ =================================================================================\e[39m"
echo -e "\e[34m +++ --> WARPING ANATOMICAL MASKS, WM, CSF AND FS PARCELLATIONS TO ${TSPACE} <--------\e[39m"
echo -e "\e[34m +++ =================================================================================\e[39m"
# Add left and right hemispheric masks
for DATA_ANAT in ${SUBJ}_T1_mask aparc.a2009s+aseg aparc.a2009s+aseg_rank lh.ribbon rh.ribbon FS_Vent FS_Vent_Superficial FS_Vent_Deep FS_WM FS_WM_Superficial FS_WM_Middle FS_WM_Deep FS_Cerebellum FS_Subcortical FS_GM FS_Rh_mask FS_Lh_mask
do
  echo -e "\e[32m ++ INFO:  Warping of ${DATA_ANAT}.nii.gz to ${TSPACE} at anatomical resolution ...\e[39m"
  3dNwarpApply -overwrite -source ${DATA_ANAT}.nii.gz                           \
               -master ${SUBJ}_T1_ns.${TSPACE}.nii.gz                           \
               -ainterp NN -nwarp anat.un.aff.qw_WARP.nii anat.un.aff.Xat.1D    \
               -prefix ${DATA_ANAT}.ANAT.${TSPACE}.nii.gz
done


echo -e "\e[34m +++ ====================================================================================\e[39m"
echo -e "\e[34m +++ ------------> END OF SCRIPT: ANATOMICAL PREPROCESSING FINISHED   <------------------\e[39m"
echo -e "\e[34m +++ ====================================================================================\e[39m"
