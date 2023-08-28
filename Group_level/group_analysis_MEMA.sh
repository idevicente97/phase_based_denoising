#!/bin/bash
#$ -cwd
#$ -o out.txt
#$ -e err.txt
#$ -m be
#$ -N Group analysis MEMA
#$ -S /bin/bash

if [[ -z "${PRJDIR}" ]]; then
  if [[ ! -z "$1" ]]; then
     SUBJ=$1
  else
     echo -e "\e[31m++ ERROR: You need to input PRJDIR as ENVIRONMENT VARIABLE or $1. Exiting!! ...\e[39m"
     exit
  fi
fi

if [[ ! -d ${PRJDIR}/PREPROC/00_Group_analysis ]]; then
    echo "\e[35m ++ Creating ${PRJDIR}/PREPROC/00_Group_analysis ...\e[39m"
    mkdir -p ${PRJDIR}/PREPROC/00_Group_analysis
else
    echo -e "\e[35m ++ WARNING: ${PRJDIR}/PREPROC/00_Group_analysis already exist. Will overwrite results!! ...\e[39m"
fi

cd ${PRJDIR}/PREPROC/00_Group_analysis

MEMA_RAW () {

GLM_TYPE=GLM_mag_REML
CONT_TYPE1=Scramble
CONT_TYPE2=Sentence


3dMEMA -overwrite -prefix RAW.3dMEMA.Sent-List.nii.gz							\
			-mask MNI152_2009_template_resampled_mask.nii.gz									\
			-missing_data 0 \
			-conditions LIST SENT \
			-set LIST \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Tstat]"		\
		  		02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Tstat]"		\
		  		# .
		  		# .
		  		# .
		  		40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Tstat]"			\
			-set SENT \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Tstat]"		\
		  		02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Tstat]"		\
		  		# .
		  		# .
		  		# .
		  		40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Tstat]"

3drefit -addFDR RAW.3dMEMA.Sent-List.nii.gz

}


MEMA_OLS () {

GLM_TYPE=GLM_lsqrs_REML
CONT_TYPE1=Scramble
CONT_TYPE2=Sentence


3dMEMA -overwrite -prefix OLS.3dMEMA.Sent-List.nii.gz							\
			-mask MNI152_2009_template_resampled_mask.nii.gz									\
			-missing_data 0 \
			-conditions LIST SENT \
			-set LIST \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Tstat]"		\
		  		02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Tstat]"		\
		  		# .
		  		# .
		  		# .
		  		40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Tstat]"			\
			-set SENT \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Tstat]"		\
		  		02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Tstat]"		\
		  		# .
		  		# .
		  		# .
		  		40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Tstat]"


3drefit -addFDR OLS.3dMEMA.Sent-List.nii.gz
}

MEMA_ODR () {

GLM_TYPE=GLM_odr_REML
CONT_TYPE1=Scramble
CONT_TYPE2=Sentence


3dMEMA -overwrite -prefix ODR.3dMEMA.Sent-List.nii.gz							\
			-mask MNI152_2009_template_resampled_mask.nii.gz									\
			-missing_data 0 \
			-conditions LIST SENT \
			-set LIST \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Tstat]"		\
		  		02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Tstat]"		\
		  		# .
		  		# .
		  		# .
		  		40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Tstat]"			\
			-set SENT \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Tstat]"		\
		  		02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Tstat]"		\
		  		# .
		  		# .
		  		# .
		  		40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Tstat]"

3drefit -addFDR ODR.3dMEMA.Sent-List.nii.gz

}

MEMA_RAW_vs_ODR () {

GLM_TYPE1=GLM_odr_REML
GLM_TYPE2=GLM_mag_REML
CONT_TYPE=Sent_vs_Scrm


3dMEMA -overwrite -prefix RAW_vs_ODR.3dMEMA.Sent-List.nii.gz							\
			-mask MNI152_2009_template_resampled_mask.nii.gz									\
			-missing_data 0 \
			-conditions ODR RAW \
			-set ODR \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
			-set RAW \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"

3drefit -addFDR RAW_vs_ODR.3dMEMA.Sent-List.nii.gz

}

MEMA_RAW_vs_OLS () {

GLM_TYPE1=GLM_lsqrs_REML
GLM_TYPE2=GLM_mag_REML
CONT_TYPE=Sent_vs_Scrm


3dMEMA -overwrite -prefix RAW_vs_OLS.3dMEMA.Sent-List.nii.gz							\
			-mask MNI152_2009_template_resampled_mask.nii.gz									\
			-missing_data 0 \
			-conditions OLS RAW \
			-set OLS \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
			-set RAW \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"

3drefit -addFDR RAW_vs_OLS.3dMEMA.Sent-List.nii.gz

}

MEMA_OLS_vs_ODR () {

GLM_TYPE1=GLM_odr_REML
GLM_TYPE2=GLM_lsqrs_REML
CONT_TYPE=Sent_vs_Scrm


3dMEMA -overwrite -prefix OLS_vs_ODR.3dMEMA.Sent-List.nii.gz							\
			-mask MNI152_2009_template_resampled_mask.nii.gz									\
			-missing_data 0 \
			-conditions ODR OLS \
			-set ODR \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
			-set OLS \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"


3drefit -addFDR OLS_vs_ODR.3dMEMA.Sent-List.nii.gz
}

MEMA_HighCor () {

GLM_TYPE=GLM_mag_REML.HighCor
CONT_TYPE1=Scramble
CONT_TYPE2=Sentence


3dMEMA -overwrite -prefix RAW.3dMEMA.HighCor.Sent-List.nii.gz							\
			-mask MNI152_2009_template_resampled_mask.nii.gz									\
			-missing_data 0 \
			-conditions LIST SENT \
			-set LIST \				
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Tstat]"		\
		  		02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Tstat]"		\
		  		# .
		  		# .
		  		# .
		  		40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Tstat]"			\
			-set SENT \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Tstat]"		\
		  		02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Tstat]"		\
		  		# .
		  		# .
		  		# .
		  		40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Tstat]"


3drefit -addFDR RAW.3dMEMA.HighCor.Sent-List.nii.gz
}

MEMA_tCompCor () {

GLM_TYPE=GLM_mag_REML.tCompCor
CONT_TYPE1=Scramble
CONT_TYPE2=Sentence


3dMEMA -overwrite -prefix RAW.3dMEMA.tCompCor.Sent-List.nii.gz							\
			-mask MNI152_2009_template_resampled_mask.nii.gz									\
			-missing_data 0 \
			-conditions LIST SENT \
			-set LIST \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Tstat]"		\
		  		02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Tstat]"		\
		  		# .
		  		# .
		  		# .
		  		40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE1}#0_Tstat]"			\
			-set SENT \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Tstat]"		\
		  		02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Tstat]"		\
		  		# .
		  		# .
		  		# .
		  		40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE}.stats.blur.MNI.nii.gz[${CONT_TYPE2}#0_Tstat]"

3drefit -addFDR RAW.3dMEMA.tCompCor.Sent-List.nii.gz
}

MEMA_Raw_vs_tCompCor() {

GLM_TYPE1=GLM_mag_REML.tCompCor
GLM_TYPE2=GLM_mag_REML
CONT_TYPE=Sent_vs_Scrm


3dMEMA -overwrite -prefix RAW_vs_tCompCor.3dMEMA.Sent-List.nii.gz							\
			-mask MNI152_2009_template_resampled_mask.nii.gz									\
			-missing_data 0 \
			-conditions tCompCor RAW \
			-set tCompCor \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
			-set RAW \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"

3drefit -addFDR RAW_vs_tCompCor.3dMEMA.Sent-List.nii.gz
}

MEMA_Raw_vs_HighCor() {

GLM_TYPE1=GLM_mag_REML.HighCor
GLM_TYPE2=GLM_mag_REML
CONT_TYPE=Sent_vs_Scrm


3dMEMA -overwrite -prefix RAW_vs_HighCor.3dMEMA.Sent-List.nii.gz							\
			-mask MNI152_2009_template_resampled_mask.nii.gz									\
			-missing_data 0 \
			-conditions HighCor RAW \
			-set HighCor \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
			-set RAW \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"


3drefit -addFDR RAW_vs_HighCor.3dMEMA.Sent-List.nii.gz
}

MEMA_tCompCor_vs_HighCor() {

GLM_TYPE1=GLM_mag_REML.HighCor
GLM_TYPE2=GLM_mag_REML.tCompCor
CONT_TYPE=Sent_vs_Scrm


3dMEMA -overwrite -prefix tCompCor_vs_HighCor.3dMEMA.Sent-List.nii.gz							\
			-mask MNI152_2009_template_resampled_mask.nii.gz									\
			-missing_data 0 \
			-conditions HighCor tCompCor \
			-set HighCor \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
			-set tCompCor \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"


3drefit -addFDR tCompCor_vs_HighCor.3dMEMA.Sent-List.nii.gz
}

MEMA_HighCor_vs_ODR() {

GLM_TYPE1=GLM_odr_REML
GLM_TYPE2=GLM_mag_REML.HighCor
CONT_TYPE=Sent_vs_Scrm


3dMEMA -overwrite -prefix HighCor_vs_ODR.3dMEMA.Sent-List.nii.gz							\
			-mask MNI152_2009_template_resampled_mask.nii.gz									\
			-missing_data 0 \
			-conditions ODR HighCor \
			-set ODR \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
			-set HighCor \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"


3drefit -addFDR HighCor_vs_ODR.3dMEMA.Sent-List.nii.gz
}

MEMA_tCompCor_vs_ODR() {

GLM_TYPE1=GLM_odr_REML
GLM_TYPE2=GLM_mag_REML.tCompCor
CONT_TYPE=Sent_vs_Scrm


3dMEMA -overwrite -prefix tCompCor_vs_ODR.3dMEMA.Sent-List.nii.gz							\
			-mask MNI152_2009_template_resampled_mask.nii.gz									\
			-missing_data 0 \
			-conditions ODR tCompCor \
			-set ODR \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE1}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
			-set tCompCor \
				01 "${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj01_name/func/subj01_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				02 "${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj02_name/func/subj02_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"		\
				# .
				# .
				# .
				40 "${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Coef]"	"${PRJDIR}/PREPROC/subj40_name/func/subj40_name.${GLM_TYPE2}.stats.blur.MNI.nii.gz[${CONT_TYPE}#0_Tstat]"


3drefit -addFDR tCompCor_vs_ODR.3dMEMA.Sent-List.nii.gz
}

# SENT vs. LIST conditions on each preprocessing method
MEMA_RAW
MEMA_OLS
MEMA_ODR
MEMA_HighCor
MEMA_tCompCor

# Method1 vs. Method2 using SENT-LIST contrast maps
MEMA_RAW_vs_ODR
MEMA_RAW_vs_OLS
MEMA_OLS_vs_ODR
MEMA_Raw_vs_tCompCor
MEMA_Raw_vs_HighCor
MEMA_tCompCor_vs_HighCor
MEMA_HighCor_vs_ODR
MEMA_tCompCor_vs_ODR
