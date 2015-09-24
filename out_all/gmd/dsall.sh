subjects=$(ls -d hup6/BBL/*_sm6.nii.gz)
for s in $subjects
   do
   echo $s
   fname=$(echo $s|cut -d"." -f1)
   fslmaths $s -subsamp2 ${fname}_ds
   fslmaths ${fname}_ds -subsamp2 ${fname}_ds
done

subjects=$(ls -d hup6/HCP/*_sm6.nii.gz)
for s in $subjects
   do
   echo $s
   fname=$(echo $s|cut -d"." -f1)
   fslmaths $s -subsamp2 ${fname}_ds
   fslmaths ${fname}_ds -subsamp2 ${fname}_ds
done

subjects=$(ls -d prisma/BBL/*_sm6.nii.gz)
for s in $subjects
   do
   echo $s
   fname=$(echo $s|cut -d"." -f1)
   fslmaths $s -subsamp2 ${fname}_ds
   fslmaths ${fname}_ds -subsamp2 ${fname}_ds
done

subjects=$(ls -d prisma/HCP/*_sm6.nii.gz)
for s in $subjects
   do
   echo $s
   fname=$(echo $s|cut -d"." -f1)
   fslmaths $s -subsamp2 ${fname}_ds
   fslmaths ${fname}_ds -subsamp2 ${fname}_ds
done
