#!/usr/bin/env bash

rootdir=/import/speedy/trio_2_prisma
subjlist=$(cat $rootdir/subjectlist)
mkdir -p networks/hup6/BBL
mkdir -p seedmaps/hup6/BBL
mkdir -p gmd/hup6/BBL
mkdir -p networks/prisma/BBL
mkdir -p seedmaps/prisma/BBL
mkdir -p gmd/prisma/BBL
mkdir -p networks/hup6/HCP
mkdir -p seedmaps/hup6/HCP
mkdir -p gmd/hup6/HCP
mkdir -p networks/prisma/HCP
mkdir -p seedmaps/prisma/HCP
mkdir -p gmd/prisma/HCP

for subj in $subjlist
   do
   hup6=0
   prisma=0
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
   rs_out=$(ls -d $rootdir/$subj/*restbold*/restbold*/prestats/confound_regress_36EV)
   t1_out=$(ls -d $rootdir/$subj/*MPRAGE*/s-normsegmod)
   seedmap=$(ls $rs_out/seed_maps/*zr.nii.gz)
   tsnet=$(ls $rs_out/networks/*timecourse.txt)
   gmdvol=$(ls $t1_out/*rs-aGM_Wst.nii.gz)
   if [ "$hup6" = "1" ]
      then
      cp $seedmap seedmaps/hup6/BBL/
      cp $tsnet networks/hup6/BBL/
      cp $gmdvol gmd/hup6/BBL/
      echo ${bblid},${scanid},${seedmap},${tsnet},${gmdvol} >> hup6_bbl
   fi
   if [ "$prisma" = "1" ]
      then
      cp $seedmap seedmaps/prisma/BBL/
      cp $tsnet networks/prisma/BBL/
      cp $gmdvol gmd/prisma/BBL/
      echo ${bblid},${scanid},${seedmap},${tsnet},${gmdvol} >> prisma_bbl
   fi
   
   #HCP sequences
   rs_out=$(ls -d $rootdir/$subj/*HCP_REST_BOLD*/restbold*/prestats/confound_regress_36EV)
   t1_out=$(ls -d $rootdir/$subj/*HCP_T1*/s-normsegmod)
   seedmap=$(ls $rs_out/seed_maps/*zr.nii.gz)
   tsnet=$(ls $rs_out/networks/*timecourse.txt)
   gmdvol=$(ls $t1_out/*rs-aGM_Wst.nii.gz)
   if [ "$hup6" = "1" ]
      then
      cp $seedmap seedmaps/hup6/HCP/
      cp $tsnet networks/hup6/HCP/
      cp $gmdvol gmd/hup6/HCP/
      echo ${bblid},${scanid},${seedmap},${tsnet},${gmdvol} >> hup6_hcp
   fi
   if [ "$prisma" = "1" ]
      then
      cp $seedmap seedmaps/prisma/HCP/
      cp $tsnet networks/prisma/HCP/
      cp $gmdvol gmd/prisma/HCP/
      echo ${bblid},${scanid},${seedmap},${tsnet},${gmdvol} >> prisma_hcp
   fi
   
done
