subjects=$(cat ../bblidlist)

echo "bblid,HUP6/BBL,HUP6/HCP,Prisma/BBL,Prisma/HCP" >> gmv/allvols
for s in $subjects
   do
   scans=$(grep $s ../subjectlist)
   for sc in $scans
      do
      scanid=$(echo $sc|cut -d"_" -f2)
      isHUP6=$(grep $scanid ../HUP6)
      isPrisma=$(grep $scanid ../PRISMA)
      if [ "X" != "X$isHUP6" ]
         then scanner=HUP6
      elif [ "X" != "X$isPrisma" ]
         then scanner=PRISMA
      fi
      segmentation=$(ls ../${sc}/*_MPRAGE*/s-normsegmod/*_seg.nii.gz)
      if [ "X" = "X$segmentation" ]
         then segmentation=$(ls ../${sc}/*_MPRAGE*/s-normsegmod/*_segmentation.nii.gz)
      fi
      fslmaths $segmentation -thr 1.9 -uthr 2.1 -bin gmv/${s}_gm_${scanner}_bbl
      segmentation=$(ls ../${sc}/*HCP_T1*/s-normsegmod/*_seg.nii.gz)
      if [ "X" = "X$segmentation" ]
         then segmentation=$(ls ../${sc}/*_MPRAGE*/s-normsegmod/*_segmentation.nii.gz)
      fi
      fslmaths $segmentation -thr 1.9 -uthr 2.1 -bin gmv/${s}_gm_${scanner}_hcp
   done
   conditions="HUP6_bbl HUP6_hcp PRISMA_bbl PRISMA_hcp"
   volvec=$s
   for c in $conditions
      do
      curvol=$(fslstats gmv/${s}_gm_${c}.nii.gz -V|cut -d" " -f2)
      volvec=$volvec,$curvol
   done
   echo $volvec >> gmv/allvols
done
