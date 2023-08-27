#$ -S /bin/bash
#$ -cwd
#$ -m be
#$ -M idevicente@bcbl.eu
#$ -q long.q 

if [[ -z "${PRJDIR}" ]]; then
  if [[ ! -z "$1" ]]; then
     PRJDIR=$1
  else
     echo -e "\e[31m++ ERROR: You need to input $1 as ENVIRONMENT VARIABLE. Exiting!! ...\e[39m"
     exit
  fi
fi
if [[ -z "${SUBJ}" ]]; then
  if [[ ! -z "$2" ]]; then
     SUBJ=$2
  else
     echo -e "\e[31m++ ERROR: You need to input $2 as ENVIRONMENT VARIABLE. Exiting!! ...\e[39m"
     exit
  fi
fi

cd ${PRJDIR}/PREPROC/${SUBJ}/anat/

# METHOD 1 - T1w/T2w ratio

3dSkullStrip -input ${SUBJ}_ses-CRANEOFUNCIONAL1_T1w.nii.gz -prefix rm.T1w_masked.nii.gz -push_to_edge -overwrite
3dmask_tool -fill_holes -dilate_input -1 1 -inputs rm.T1w_masked.nii.gz -prefix ${SUBJ}_mask_base_T1.nii.gz -overwrite

3dZeropad -master ${SUBJ}_ses-CRANEOFUNCIONAL1_T1w.nii.gz -prefix ${SUBJ}_ses-CRANEOFUNCIONAL1_T2w_Zeropad.nii.gz ${SUBJ}_ses-CRANEOFUNCIONAL1_T2w.nii.gz -overwrite

align_epi_anat.py -overwrite -dset1 ${SUBJ}_ses-CRANEOFUNCIONAL1_T1w.nii.gz -dset2 ${SUBJ}_ses-CRANEOFUNCIONAL1_T2w.nii.gz -dset1to2 -rigid_body -dset1_strip None -dset2_strip None

3dcalc -float -a ${SUBJ}_ses-CRANEOFUNCIONAL1_T1w_al+orig -b ${SUBJ}_ses-CRANEOFUNCIONAL1_T2w_Zeropad.nii.gz -m ${SUBJ}_mask_base_T1.nii.gz -expr 'm*(bool(b)*a/b)' -prefix T1wT2w_ratio.nii.gz -overwrite

3dresample -master ../func/${SUBJ}_T1_ns.al_epi.nii.gz -prefix rm.T1wT2w_ratio_resamp.nii.gz -input T1wT2w_ratio.nii.gz -overwrite

3dAllineate -base ../func/${SUBJ}_T1_ns.al_epi.nii.gz -prefix T1wT2w_ratio_al.nii.gz -input rm.T1wT2w_ratio_resamp.nii.gz -overwrite

rm rm*

cp T1wT2w_ratio_al.nii.gz ../func/

cd ../func/

MEDIAN=$(3dROIstats -overwrite -quiet -nomeanout -mask ${SUBJ}_T1_mask.al_epi.ANAT.nii.gz -nzmedian T1wT2w_ratio_al.nii.gz)

3dcalc -float -a T1wT2w_ratio_al.nii.gz -expr "min(step(2.18*a/$MEDIAN-6.5),50)/50" -prefix Veins_T1wT2w_thr6.5.nii.gz

# METHOD 2 - Filtered tSTD map

TR_COUNTS=$(3dinfo -nt ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz)
TR=$(3dinfo -TR ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz)
POLORTORDER=$(echo "scale=3;(${TR_COUNTS}*${TR})/150" | bc | xargs printf "%.*f\n" 0)
POLORTORDER=$(echo "1+${POLORTORDER}" | bc)

3dTproject -polort ${POLORTORDER} -passband 0.25 10 -input ${SUBJ}.magnitude.pb03_volreg_detrended_masked.nii.gz -prefix Veins_hpf_0.25.nii.gz

3dTstat -stdevNOD -prefix Veins_tSTD_hpf_0.25.nii.gz Veins_hpf_0.25.nii.gz

3dcalc -a Veins_tSTD_hpf_0.25.nii.gz -expr 'astep(a,375)' -prefix Veins_tSTD_hpf_0.25_thr375.nii.gz
