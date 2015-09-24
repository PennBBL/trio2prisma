subjects=$(ls -d hup6/BBL/*.nii.gz)
for s in $subjects
   do
   echo $s
   fname=$(echo $s|cut -d"." -f1)
   fslmaths $s -s 2.54 ${fname}_sm6
done

subjects=$(ls -d hup6/HCP/*.nii.gz)
for s in $subjects
   do
   echo $s
   fname=$(echo $s|cut -d"." -f1)
   fslmaths $s -s 2.54 ${fname}_sm6
done

subjects=$(ls -d prisma/BBL/*.nii.gz)
for s in $subjects
   do
   echo $s
   fname=$(echo $s|cut -d"." -f1)
   fslmaths $s -s 2.54 ${fname}_sm6
done

subjects=$(ls -d prisma/HCP/*.nii.gz)
for s in $subjects
   do
   echo $s
   fname=$(echo $s|cut -d"." -f1)
   fslmaths $s -s 2.54 ${fname}_sm6
done

