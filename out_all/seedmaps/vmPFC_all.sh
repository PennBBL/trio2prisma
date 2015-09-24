bblids=$(cat ../../bblidlist)

# create spherical mask centred in vmPFC
# mask centre was empirically determined as max of mean
fslmaths ../4mmstd_mask.nii.gz -mul 0 -add 1 -roi 22 1 44 1 16 1 0 1 -kernel sphere 10 -fmean -bin vmPFC
rm -f all_vmPFC_mean
touch all_vmPFC_mean

for bblid in $bblids
   do
   
   # image paths
   hup6_bbl=$(ls hup6/BBL/${bblid}*ds.nii.gz)
   hup6_hcp=$(ls hup6/HCP/${bblid}*ds.nii.gz)
   prisma_bbl=$(ls prisma/BBL/${bblid}*ds.nii.gz)
   prisma_hcp=$(ls prisma/HCP/${bblid}*ds.nii.gz)
   
   # compute mean
   hup6_bbl=$(fslstats $hup6_bbl -k vmPFC -M|cut -d" " -f1)
   hup6_hcp=$(fslstats $hup6_hcp -k vmPFC -M|cut -d" " -f1)
   prisma_bbl=$(fslstats $prisma_bbl -k vmPFC -M|cut -d" " -f1)
   prisma_hcp=$(fslstats $prisma_hcp -k vmPFC -M|cut -d" " -f1)
   
   # write to file
   echo $bblid,$hup6_bbl,$hup6_hcp,$prisma_bbl,$prisma_hcp>>all_vmPFC_mean
   
done
