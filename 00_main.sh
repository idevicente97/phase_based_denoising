#$ -S /bin/bash
#$ -cwd
#$ -m be
#$ -M idevicente@bcbl.eu

# Varibles to adapt
PRJDIR=~/path/to/my/data # change for the directory where you stored the data
SUMADIR=~/path/to/SUMA # change for the directory where you have AFNI's SUMA package
ROIDIR=~/path/to/ROI # if applies, change for the directory where you'll store your ROI masks

list_subjects=(my_subject_list) # change for your list of subjects (e.g. list_subjects=('SUBJ01' 'SUBJ02' ...))
list_runs=(my_run_list) # if applies, change for list of each corresponding subject's run type (e.g. list_runs=('01' '02' ...))
list_onset_order=(my_onset_order_list) # if applies, change for list of each corresponding subject's onset time order (e.g. list_onset_order=('A' 'B' ...))

# Set up rest of variables
BASEDIR=$(pwd)
CENSOR_MOTION_TH_2USE="0.3" # Motion censoring threshold
CENSOR_TYPE_2USE="enorm" # Motion censoring type

module load afni/latest
module load python/python3

for i in ${!list[*]}
do
	SUBJ=${list_subjects[$i]}
  # Our study involved different sets of run times, remove if it is not your case
	RUN=${list_runs[$i]}
  # Our study involved different sets of stimuli onset times, remove if it is not your case
	ORDER=${list_onset_order[$i]}
  
  sh ${BASEDIR}/Subject_level/01_functional_magnitude.sh ${SUBJ} ${RUN} ${PRJDIR}	 # Magnitude preprocessing script
  sh ${BASEDIR}/Subject_level/02_functional_phase.sh ${SUBJ} ${RUN} ${PRJDIR} ${BASEDIR}			# Phase preprocessing script
  sh ${BASEDIR}/Subject_level/03_functional_phaseregression.sh ${SUBJ} ${PRJDIR} ${BASEDIR}			# Phase regression (ODR, Lsqrs) script
  sh ${BASEDIR}/Subject_level/04a_functional_GLM.MEMA.sh ${SUBJ} ${PRJDIR} ${ORDER} ${CENSOR_TYPE_2USE} ${CENSOR_MOTION_TH_2USE}		# Deconvolve script for 3dMEMA
  sh ${BASEDIR}/Subject_level/04b_functional_GLM_CompCor.MEMA.sh ${SUBJ} ${PRJDIR} ${ORDER} ${CENSOR_TYPE_2USE} ${CENSOR_MOTION_TH_2USE}		# Deconvolve script for 3dMEMA with CompCor regressors included
  sh ${BASEDIR}/Subject_level/04c_functional_GLM_HighCor.MEMA.sh ${SUBJ} ${PRJDIR} ${ORDER} ${CENSOR_TYPE_2USE} ${CENSOR_MOTION_TH_2USE}		# Deconvolve script for 3dMEMA with HighCor regressors included
  sh ${BASEDIR}/Subject_level/05_anatomical.sh ${PRJDIR} ${SUBJ} ${SUMADIR}              # Anatomical preprocessing 
  sh ${BASEDIR}/Subject_level/06_warpingMNI.sh ${PRJDIR} ${SUBJ}                         # Warping to MNI space 
  # optional
  # sh ${BASEDIR}/Subject_level/vein_mapping.sh ${PRJDIR} ${SUBJ}                         # Computing vein delineation maps
done

sh ${BASEDIR}/Group_level/group_analysis_MEMA.sh # Calculate Group-level activation maps and denoising-difference maps
sh ${BASEDIR}/Subject_level/ROI_betas.sh ${PRJDIR} ${ROIDIR}                # Calculating betas for each ROI
