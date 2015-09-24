#!/usr/bin/env bash

rootdir=/import/speedy/trio_2_prisma
subjlist=$(cat $rootdir/bblidlist)
#subjlist=19465
mkdir -p ccmats/gmd
mkdir -p ccmats/pcc

for bblid in $subjlist
   do
   echo $bblid
   
   #GM density
   triobbl=$(grep $bblid hup6_bbl|cut -d"," -f5)
   prismabbl=$(grep $bblid prisma_bbl|cut -d"," -f5)
   triohcp=$(grep $bblid hup6_hcp|cut -d"," -f5)
   prismahcp=$(grep $bblid prisma_hcp|cut -d"," -f5)
   conditions="$triobbl $triohcp $prismabbl $prismahcp"
   echo $conditions
   for c1 in $conditions
      do
      curvec=""
      for c2 in $conditions
         do
         curcc=$(fslcc $c1 $c2|rev|cut -d" " -f1|rev)
         #echo "$c1 and $c2 : $curcc"
         if [ "$curvec" = "" ]
            then
            curvec=$curcc
         else
            curvec=$curvec,$curcc
         fi
      done
      echo $curvec >> ccmats/gmd/${bblid}_gmd
   done
   
   #SCA maps
   triobbl=$(grep $bblid hup6_bbl|cut -d"," -f3)
   prismabbl=$(grep $bblid prisma_bbl|cut -d"," -f3)
   triohcp=$(grep $bblid hup6_hcp|cut -d"," -f3)
   prismahcp=$(grep $bblid prisma_hcp|cut -d"," -f3)
   conditions="$triobbl $triohcp $prismabbl $prismahcp"
   echo $conditions
   for c1 in $conditions
      do
      curvec=""
      for c2 in $conditions
         do
         curcc=$(fslcc $c1 $c2|rev|cut -d" " -f1|rev)
         if [ "$curvec" = "" ]
            then
            curvec=$curcc
         else
            curvec=$curvec,$curcc
         fi
      done
      echo $curvec >> ccmats/pcc/${bblid}_pcc
   done
   
done
