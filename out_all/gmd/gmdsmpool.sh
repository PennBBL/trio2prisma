rootdir=/import/speedy/trio_2_prisma
subjlist=$(cat $rootdir/subjectlist)

for subj in $subjlist
   do
   bblid=$(echo $subj|cut -d"_" -f1)
   scanid=$(echo $subj|cut -d"_" -f2)
   sc1=$(grep $scanid $rootdir/HUP6)
   sc2=$(grep $scanid $rootdir/PRISMA)
   if [ "$sc1" = "$scanid" ]
      then
      hup6=1
      prisma=0
   fi
   if [ "$sc2" = "$scanid" ]
      then
      hup6=0
      prisma=1
   fi
   
   #BBL sequences
   if [ "$hup6" = "1" ]
      then
      net=$(ls hup6/BBL/*${scanid}*_sm*.nii.gz)
      echo ${bblid},${scanid},${net} >> hup6_bbl_gmd
      net=$(ls hup6/HCP/*${scanid}*_sm*.nii.gz)
      echo ${bblid},${scanid},${net} >> hup6_hcp_gmd
   fi
   if [ "$prisma" = "1" ]
      then
      net=$(ls prisma/BBL/*${scanid}*_sm*.nii.gz)
      echo ${bblid},${scanid},${net} >> prisma_bbl_gmd
      net=$(ls prisma/HCP/*${scanid}*_sm*.nii.gz)
      echo ${bblid},${scanid},${net} >> prisma_hcp_gmd
   fi
   
done
