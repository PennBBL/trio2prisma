#define subject list
subjects=19465_9793
#subjects=$(cat subjectlist)

#define fixed arguments
template=/import/monstrum/Applications/fsl5/data/standard/MNI152_T1_2mm_brain.nii.gz
coreg_method=bbr
smooth=2.54
seed=/import/speedy/trio_2_prisma/PCCseed.nii.gz
#network=/import/monstrum/day2_fndm/group_level_analyses/card_face/ROIs/n45_BDI_z23_p05.nii.gz
#network=/import/monstrum/day2_fndm/kable_rois/easythresh/valueNetwork.nii.gz
#seed=/import/monstrum/day2_fndm/kable_rois/easythresh/kable_vs_pos_gt_neg.nii.gz
network=/import/speedy/trio_2_prisma/power264rois.nii.gz
#network=/import/speedy/eons/rois/power264_rois/power264rois.nii.gz
#seed=/import/monstrum/day2_fndm/group_level_analyses/card_face/ROIs/n77_VS_z7.nii.gz
#network=/import/monstrum/day2_fndm/group_level_analyses/restbold/ROIs/kable_pos_sv_coord_6mm_radius.nii.gz
config=/import/speedy/scripts/bin/restbold_config
#define logs
dico_log=nodico
t1_log=not1

#remove logs
rm -f $dico_log
rm -f $t1_log

for s in $subjects; do
	echo ""
	echo $s
	subj=$s
	scanid=$(echo $s | cut -d_ -f2)
	subjdir=$(ls -d /import/speedy/trio_2_prisma/${subj})

	#check that series is present
	seriesdir=$(ls -d $subjdir/*HCP_REST_BOLD*/)
	if [ ! -e "$seriesdir" ]; then
		echo "restbold not acquired"
		continue
	fi

	#check that restbold TS is present--assume was already dico'd
	nifti=$(ls $seriesdir/nifti/*.nii)
	if [ ! -e "$nifti" ]; then
		echo "no nifti made for this sujbect; will log!"
		echo $subj >> $dico_log
		continue
	fi
	
	# example dicom
	example_dicom=$(ls $seriesdir/dicoms/*dicom.DCM)
	dicodir=$(ls -d $subjdir/dicoB0calc)
	b0m=$dicodir/dico_mag1.nii
	b0p=$dicodir/dico_rpsmap.nii
	#b0p=$dicodir/dico_pha1.nii
	dicomask=$dicodir/dico_mask.nii

	#check structural dependencies
	mpragedir=$(ls -d $subjdir/*HCP_T1*)
	t1brain=$(ls $mpragedir/nifti/*.nii)
	t1seg=$(ls $mpragedir/s-normsegmod/*${scanid}_mprage_segmentation.nii)
	ants_warp=$(ls $mpragedir/s-normsegmod/mni152_brain_f_*_mprage_rs_m_2Warp.nii.gz)
	ants_affine=$(ls $mpragedir/s-normsegmod/mni152_brain_f_*_mprage_rs_m_1Affine.mat)
	ants_rigid=$(ls $mpragedir/s-normsegmod/mni152_brain_f_*_mprage_rs_m_0DerivedInitialMovingTranslation.mat)

	if [ ! -e "$t1brain" ] || [ ! -e "$t1seg" ] || [ ! -e "$ants_warp" ]; then
		echo "one or more t1 inputs are missing; will log"
		echo $subj >> $t1_log
		continue
	fi

	dir=$seriesdir/restbold_pipeline_20140324

	#check if output is present
	output=$(ls $dir/prestats/confound_regress_36EV/networks/*network*)
	# output=$(ls $dir/${prestatsname}.feat/confound_regress_24EV/seed_maps/*kable_pos_sv_VS_coord_6mm_radius_sigma2.54_zr.nii.gz 2> /dev/null)
	if [ -e "$output" ]; then
		echo "output already present"
		continue
	fi
	echo "running restbold pipeline on subj $subj"

	
#        ~/working_tree/restbold/restbold_pipeline_20140407.sh --subj=$subj --dir=$dir --prestats_design=$prestats_design --t1brain=$t1brain --t1seg=$t1seg  --t1seg_vals=10,150,250 --input_nifti=$nifti --dramms=$dramms --template=$template --smooth=$smooth --coreg_method=$coreg_method --seed=$seed --network=$network --config=$config


qsub -V -q all.q -S /bin/bash -o ~/sge_out -e ~/sge_out -cwd /import/speedy/trio_2_prisma/restbold_pipeline_20140407.sh --subj=$subj --dir=$dir --t1brain=$t1brain --t1seg=$t1seg  --t1seg_vals=1,2,3 --input_nifti=$nifti --ants_warp=$ants_warp --ants_affine=$ants_affine --ants_rigid=$ants_rigid --template=$template --smooth=$smooth --coreg_method=$coreg_method --seed=$seed --config=$config --network=$network 
# -d --example_dicom=$example_dicom --mag_map=$b0m --rps_map=$b0p --b0_mask=$dicomask

done

