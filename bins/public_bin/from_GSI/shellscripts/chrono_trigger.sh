#! /bin/bash


export LD_LIBRARY_PATH=/usr/lib:/usr/X11R6/lib:/u/$USER_flast/MyBuild_32/lib:/misc/cbmsoft/Debian3.1/new/tools/root/lib:/misc/cbmsoft/Debian3.1/new/transport/geant3/lib/tgt_linux:/misc/cbmsoft/Debian3.1/new/generators/lib:/misc/cbmsoft/Debian3.1/new/generators/lib:/misc/cbmsoft/Debian3.1/new/transport/geant4/lib/Linux-g++:/misc/cbmsoft/Debian3.1/new/transport/geant4_vmc/lib/tgt_linux:/misc/cbmsoft/Debian3.1/new/transport/vgm/lib/Linux-g++:/misc/cbmsoft/Debian3.1/new/cern/clhep/lib

export ROOTSYS=/misc/cbmsoft/Debian3.1/new/tools/root


#/bin/bash .bash_profile
#echo $LSF_ENVDIR
export LSF_ENVDIR=/LSF/lsf/conf
#echo $LSF_ENVDIR
#ls /LSF/lsf/conf/lsf.conf
/LSF/lsf/bin/bjobs > ~/bjobs.txt

  /u/$USER_flast/bin/programs/check_integrity /d/cbm03/urqmd/auau/25gev/centr/urqmd.auau.25gev.centr.0000.ftn14 "cbmsim" "TTree" 1000 4 1;
  echo "return value=$?"
