#!/bin/bash
#This is the ultimate transport shellscript. It is to be used by crontab. :D
#Every day at 00:00:00, it shall be launched and eradicate all corrupted MC files. >:->

#1)check job existence
#2)check file existence
#3)check file integrity
#4)check nb of events

############################################################################################
# Define a bunch of stuff like LSF_ENVDIR to make it crontab compatible... :D
############################################################################################

bash .bash_profile
export LSF_ENVDIR=/LSF/lsf/conf
export PATH=/u/$USER_flast/bin/:/u/$USER_flast/bin/programs:/u/$USER_flast/bin/shellscripts:/misc/cbmsoft/Debian3.1/new/tools/root/bin/:$PATH
export ROOTSYS=/misc/cbmsoft/Debian3.1/new/tools/root
export LD_LIBRARY_PATH=/usr/lib:/usr/X11R6/lib:/u/$USER_flast/MyBuild_32/lib:/misc/cbmsoft/Debian3.1/new/tools/root/lib:/misc/cbmsoft/Debian3.1/new/transport/geant3/lib/tgt_linux:/misc/cbmsoft/Debian3.1/new/generators/lib:/misc/cbmsoft/Debian3.1/new/generators/lib:/misc/cbmsoft/Debian3.1/new/transport/geant4/lib/Linux-g++:/misc/cbmsoft/Debian3.1/new/transport/geant4_vmc/lib/tgt_linux:/misc/cbmsoft/Debian3.1/new/transport/vgm/lib/Linux-g++:/misc/cbmsoft/Debian3.1/new/cern/clhep/lib

############################################################################################
# Constants
############################################################################################

PARTICLE=neutrino;
JOB=transport;
PLUTO=4;
URQMD=2;
ENERGY=25;
VERBOSE=1;
CREATE=0;
LOGDIR=/SAT/s/$USER_flast/logs;
list_particle="Jpsi Psi_prime";
#list_energy="15 25 35";
list_energy="25";
#list_trigger="centr mbias";
list_trigger="centr";
list_Pluto="Pluto noPluto";
list_Urqmd="Urqmd noUrqmd";
list_geometry="much_large.geo much_half_large.geo";

# echo ENERGY=$ENERGY\gev
#TITLE="System Information for $HOSTNAME"
#RIGHT_NOW=$(date +"%x %r %Z")
#TIME_STAMP="Updated on $RIGHT_NOW by $USER"

# jpsi/psi_prime
# 15/25/35
# Pluto/Urqmd/Pluto+Urqmd
# centr/mbias
#
# 2*3*3*2=36 partial combos
# 200 files=>36*200=7200 full combos
# sim+sts+much=>3*7200=21600 jobs!!!

############################################################################################
# FUNCTIONS
############################################################################################

script_help()
{
  echo;
  echo "usage :";
  echo "$0 nEvents start_index end_index";
  echo;
}

generate_all_jobnames()
{
# jpsi/psi_prime
# 15/25/35
# Pluto/Urqmd/Pluto+Urqmd
# centr/mbias

  SIM_job=SIM_$particle\.$energy\gev.$Pluto\.$Urqmd\.$trigger\.$index\.$geometry;
  STS_job=STS_$particle\.$energy\gev.$Pluto\.$Urqmd\.$trigger\.$index\.$geometry;
  MUCH_job=MUCH_$particle\.$energy\gev.$Pluto\.$Urqmd\.$trigger\.$index\.$geometry;
}

generate_all_filenames()
{
# echo /d/cbm03/urqmd/auau/$energy\gev/$trigger\/urqmd.auau.$energy\gev.$trigger\.
# echo $maindir/$Pluto\.$Urqmd\.auau.$energy\gev.$trigger

  ftn14_base=/d/cbm03/urqmd/auau/$energy\gev/$trigger\/urqmd.auau.$energy\gev.$trigger\.;
  output_base=$maindir/$Pluto\.$Urqmd\.auau.$energy\gev.$trigger;
  
  MC_base="$output_base.mc.";
  params_base="$output_base.params.";
  sts_reco_base="$output_base.sts_reco.";
  much_reco_base="$output_base.much_reco.";
  
  ftn14_file=`filename_generator $ftn14_base $index ".ftn14"`;
  MC_file=`filename_generator $MC_base $index ".root"`;
  params_file=`filename_generator $params_base $index ".root"`;
  digi_file=~/cbmroot/parameters/sts/sts_standard.gsi.digi.par;
  sts_reco_file=`filename_generator $sts_reco_base $index ".root"`;
  much_reco_file=`filename_generator $much_reco_base $index ".root"`;
}

set_bools()
{
#if((ftn14) && !(mc && params) && (!SIM)) =>SIM
#if((mc && params && digi) && !(sts_reco) && (!SIM && !STS)) =>STS
#if((mc && params && sts_reco && digi) && !(much_reco) && (!SIM && !STS && !MUCH)) =>MUCH

  MC=$1;
  params=$2;
  digi=$3;
  sts_reco=$4;
  much_reco=$5;
  SIM=$6;
  STS=$7;
  MUCH=$8;
}

display_bools()
{
  echo ftn14=$ftn14;
  echo MC=$MC;
  echo params=$params;
  echo digi=$digi;
  echo sts_reco=$sts_reco;
  echo much_reco=$much_reco;
  echo SIM=$SIM;
  echo STS=$STS;
  echo MUCH=$MUCH;
}

check_job()
{
  jobname=$1
  var=`/LSF/lsf/bin/bjobs -J $jobname 2>&1 | grep -c "not found"`
  if [ $var -eq 0 ]
  then
    if [ $VERBOSE == "1" ]; then echo "$jobname does exist."; fi;
    return 1;
  else
    if [ $VERBOSE == "1" ]; then echo "$jobname does not exist."; fi;
    return 0;
  fi
}

check_all_jobs()
{
  var=`/LSF/lsf/bin/bjobs -J $SIM_job 2>&1 | grep -c "not found"`
  if [ $var -eq 0 ]
  then
    if [ $VERBOSE == "1" ]; then echo "$SIM_job does exist."; fi;
    SIM=1;
  else
    if [ $VERBOSE == "1" ]; then echo "$SIM_job does not exist."; fi;
    SIM=0;
  fi
  
  var=`/LSF/lsf/bin/bjobs -J $STS_job 2>&1 | grep -c "not found"`
  if [ $var -eq 0 ]
  then
    if [ $VERBOSE == "1" ]; then echo "$STS_job does exist."; fi;
    STS=1;
  else
    if [ $VERBOSE == "1" ]; then echo "$STS_job does not exist."; fi;
    STS=0;
  fi
  
  var=`/LSF/lsf/bin/bjobs -J $MUCH_job 2>&1 | grep -c "not found"`
  if [ $var -eq 0 ]
  then
    if [ $VERBOSE == "1" ]; then echo "$MUCH_job does exist."; fi;
    MUCH=1;
  else
    if [ $VERBOSE == "1" ]; then echo "$MUCH_job does not exist."; fi;
    MUCH=0;
  fi
}

check_all_files()
{
# pattern=7=existence+structure+Nevents
# pattern=5=existence+Nevents
# pattern=2=structure

#Normal check.
#   /u/$USER_flast/bin/programs/check_integrity $ftn14_file "cbmsim" "TTree" $nEvents 4 $VERBOSE >/dev/null 2>&1; ftn14=$?;
#   /u/$USER_flast/bin/programs/check_integrity $MC_file "cbmsim" "TTree" $nEvents 7 $VERBOSE >/dev/null 2>&1; MC=$?;
#   /u/$USER_flast/bin/programs/check_integrity $params_file "cbmsim" "TTree" $nEvents 4 $VERBOSE >/dev/null 2>&1; params=$?;
#   /u/$USER_flast/bin/programs/check_integrity $digi_file "cbmsim" "TTree" $nEvents 4 $VERBOSE >/dev/null 2>&1; digi=$?;
#   /u/$USER_flast/bin/programs/check_integrity $sts_reco_file "cbmsim" "TTree" $nEvents 7 $VERBOSE >/dev/null 2>&1; sts_reco=$?;
#   /u/$USER_flast/bin/programs/check_integrity $much_reco_file "cbmsim" "TTree" $nEvents 7 $VERBOSE >/dev/null 2>&1; much_reco=$?;
  
#don't check nb of events or structure. Only existence.
  /u/$USER_flast/bin/programs/check_integrity $ftn14_file "cbmsim" "TTree" $nEvents 4 $VERBOSE >/dev/null 2>&1; ftn14=$?;
  /u/$USER_flast/bin/programs/check_integrity $MC_file "cbmsim" "TTree" $nEvents 4 $VERBOSE >/dev/null 2>&1; MC=$?;
  /u/$USER_flast/bin/programs/check_integrity $params_file "cbmsim" "TTree" $nEvents 4 $VERBOSE >/dev/null 2>&1; params=$?;
  /u/$USER_flast/bin/programs/check_integrity $digi_file "cbmsim" "TTree" $nEvents 4 $VERBOSE >/dev/null 2>&1; digi=$?;
  /u/$USER_flast/bin/programs/check_integrity $sts_reco_file "cbmsim" "TTree" $nEvents 4 $VERBOSE >/dev/null 2>&1; sts_reco=$?;
  /u/$USER_flast/bin/programs/check_integrity $much_reco_file "cbmsim" "TTree" $nEvents 4 $VERBOSE >/dev/null 2>&1; much_reco=$?;
}

display_filenames()
{
  echo ftn14_file=$ftn14_file
  echo MC_file=$MC_file
  echo params_file=$params_file
  echo digi_file=$digi_file
  echo sts_reco_file=$sts_reco_file
  echo much_reco_file=$much_reco_file
}

display_jobnames()
{   
  echo SIM_job=$SIM_job
  echo STS_job=$STS_job
  echo MUCH_job=$MUCH_job
}

launch_jobs()
{
#define maindir
  maindir=/SAT/s/$USER_flast/$geometry/data_$particle
  
#define Pluto_N and Urqmd_N
  if [ $Pluto == "Pluto" ]
  then
    Pluto_N=1;
  else
    Pluto_N=0;
  fi
  if [ $Urqmd == "Urqmd" ]
  then
    Urqmd_N=1;
  else
    Urqmd_N=0;
  fi
  
#filenames
  generate_all_filenames
  if [ $VERBOSE == "1" ]; then display_filenames; fi;
  
#jobnames
  generate_all_jobnames
  if [ $VERBOSE == "1" ]; then display_jobnames; fi;

#prepare the boolean variables
  check_all_files
  check_all_jobs
  if [ $VERBOSE == "1" ]; then display_bools; fi;
           
#launch jobs
  if [ \( $ftn14 == "1" \) -a ! \( $MC == "1" -a $params == "1" \) -a \( ! $SIM == "1" \) ]
  then
    echo "SIM: OK => Launching $SIM_job";
    if [ $particle == "Jpsi" ]
    then
      /LSF/lsf/bin/bsub -J $SIM_job -oo $LOGDIR/$SIM_job\.log root -b -l -q .x "~/cbmroot/macro/much/much_sim_Jpsi.C($nEvents,$index,$Pluto_N,$Urqmd_N,$energy,\"$trigger\",\"$geometry\")";
    fi
    if [ $particle == "Psi_prime" ]
    then
      /LSF/lsf/bin/bsub -J $SIM_job -oo $LOGDIR/$SIM_job\.log root -b -l -q .x "~/cbmroot/macro/much/much_sim_Psi_prime.C($nEvents,$index,$Pluto_N,$Urqmd_N,$energy,\"$trigger\",\"$geometry\")";
    fi
  else
    echo "SIM: not OK";
  fi

  if [ \( $MC == "1" -a $params == "1" -a $digi == "1" \) -a ! \( $sts_reco == "1" \) -a \( ! $SIM == "1" -a ! $STS == "1" \) ]
  then
    echo "STS: OK => Launching $STS_job";
    if [ $particle == "Jpsi" ]
    then
      /LSF/lsf/bin/bsub -J $STS_job -oo $LOGDIR/$STS_job\.log root -b -l -q .x "~/cbmroot/macro/much/sts_reco_Jpsi.C($nEvents,$index,$Pluto_N,$Urqmd_N,$energy,\"$trigger\",\"$geometry\")";
    fi
    if [ $particle == "Psi_prime" ]
    then
      /LSF/lsf/bin/bsub -J $STS_job -oo $LOGDIR/$STS_job\.log root -b -l -q .x "~/cbmroot/macro/much/sts_reco_Psi_prime.C($nEvents,$index,$Pluto_N,$Urqmd_N,$energy,\"$trigger\",\"$geometry\")";
    fi
  else
    echo "STS: not OK";
  fi
  
  if [ \( $MC == "1" -a $params == "1" -a $sts_reco == "1" -a $digi == "1" \) -a ! \( $much_reco == "1" \) -a \( ! $SIM == "1" -a ! $STS == "1" -a ! $MUCH == "1" \) ]
  then
    echo "MUCH: OK => Launching $MUCH_job";
    if [ $particle == "Jpsi" ]
    then
      /LSF/lsf/bin/bsub -J $MUCH_job -oo $LOGDIR/$MUCH_job\.log root -b -l -q .x "~/cbmroot/macro/much/much_reco_Jpsi.C($nEvents,$index,$Pluto_N,$Urqmd_N,$energy,\"$trigger\",\"$geometry\")";
    fi
    if [ $particle == "Psi_prime" ]
    then
      /LSF/lsf/bin/bsub -J $MUCH_job -oo $LOGDIR/$MUCH_job\.log root -b -l -q .x "~/cbmroot/macro/much/much_reco_Psi_prime.C($nEvents,$index,$Pluto_N,$Urqmd_N,$energy,\"$trigger\",\"$geometry\")";
    fi
  else
    echo "MUCH: not OK";
  fi
}

toto()
{
  echo "$0 says: hello $1"
  zed=42;
  exit 512;
}

check_jobname()
{
  echo
}

launch_job()
{
  echo
}

############################################################################################
# SCRIPT BODY
############################################################################################

##### Preliminaries

#display help if no parameters are present
if [ $# -eq 0 ]
then
  script_help;
fi

#set default arguments
nEvents=1000
start_index=0
end_index=199

#set arguments
if [ $1 ]; then nEvents=$1; fi;
if [ $2 ]; then start_index=$2; fi;
if [ $3 ]; then end_index=$3; fi;

#display arguments
echo nEvents=$nEvents
echo start_index=$start_index
echo end_index=$end_index

#check if processor has sse and sse2 support for libL1
#if no exit
var1=$(cat /proc/cpuinfo | grep -c sse)
var2=$(cat /proc/cpuinfo | grep -c sse2)
if [ $var1 -eq 0 -o $var1 -eq 0 ]
then
  echo "ERROR: Processor does NOT support sse or sse2.";
  exit -1;
else
  echo "Processor does support sse and sse2.";
fi

# Create joblist.txt and check if connected to an lxi machine
# If no, exit
/LSF/lsf/bin/bjobs>joblist.txt
if [ $? -eq 0 ]
then
  echo "already connected to an lxi machine"
  echo "joblist.txt creation successful"
else
  echo "ERROR: not connected to an lxi machine"
  echo "ERROR: joblist.txt creation not successful"
  exit -1
fi

##### Main loop

for (( index = $start_index ; index <= $end_index ; index++ ))
do
  for particle in $list_particle;
  do
    for energy in $list_energy;
    do
      for trigger in $list_trigger;
      do
        for Pluto in $list_Pluto;
        do
          for Urqmd in $list_Urqmd;
          do
            for geometry in $list_geometry;
            do
              if [ $Pluto == "noPluto" -a $Urqmd == "noUrqmd" ]; then continue; fi;
              if [ $Pluto == "Pluto" -a $Urqmd == "Urqmd" ]; then continue; fi;
              echo combo=$index\.$particle\.$energy\.$trigger\.$Pluto\.$Urqmd\.$geometry;
              launch_jobs;
            done;
          done;
        done;
      done;
    done;
  done;
done;

############################################################################################
# REFERENCE
############################################################################################
#SIM:
#FTN14--->[]--->MC
#         []--->Params
  
#STS:
#MC------>[]
#Params-->[]--->sts_reco
#digi---->[]
  
#MUCH:
#MC------->[]
#Params--->[]--->much_reco
#sts_reco->[]
#digi----->[]
  
#if((ftn14) && !(mc && params) && (!SIM)) =>SIM
#if((mc && params && digi) && !(sts_reco) && (!SIM && !STS)) =>STS
#if((mc && params && sts_reco && digi) && !(much_reco) && (!SIM && !STS && !MUCH)) =>MUCH

#   launch_job "Jpsi" $nEvents $index 15 0 1 "centr"
#   launch_job "Jpsi" $nEvents $index 15 1 0 "centr"
#   launch_job "Jpsi" $nEvents $index 15 1 1 "centr"
#   
#   launch_job "Jpsi" $nEvents $index 25 0 1 "centr"
#   launch_job "Jpsi" $nEvents $index 25 1 0 "centr"
#   launch_job "Jpsi" $nEvents $index 25 1 1 "centr"
#   
#   launch_job "Jpsi" $nEvents $index 35 0 1 "centr"
#   launch_job "Jpsi" $nEvents $index 35 1 0 "centr"
#   launch_job "Jpsi" $nEvents $index 35 1 1 "centr"
# 
#   launch_job "Jpsi" $nEvents $index 15 0 1 "mbias"
#   launch_job "Jpsi" $nEvents $index 15 1 0 "mbias"
#   launch_job "Jpsi" $nEvents $index 15 1 1 "mbias"
#   
#   launch_job "Jpsi" $nEvents $index 25 0 1 "mbias"
#   launch_job "Jpsi" $nEvents $index 25 1 0 "mbias"
#   launch_job "Jpsi" $nEvents $index 25 1 1 "mbias"
#   
#   launch_job "Jpsi" $nEvents $index 35 0 1 "mbias"
#   launch_job "Jpsi" $nEvents $index 35 1 0 "mbias"
#   launch_job "Jpsi" $nEvents $index 35 1 1 "mbias"
#     
#   launch_job "Psi_prime" $nEvents $index 15 0 1 "centr"
#   launch_job "Psi_prime" $nEvents $index 15 1 0 "centr"
#   launch_job "Psi_prime" $nEvents $index 15 1 1 "centr"
#   
#   launch_job "Psi_prime" $nEvents $index 25 0 1 "centr"
#   launch_job "Psi_prime" $nEvents $index 25 1 0 "centr"
#   launch_job "Psi_prime" $nEvents $index 25 1 1 "centr"
#   
#   launch_job "Psi_prime" $nEvents $index 35 0 1 "centr"
#   launch_job "Psi_prime" $nEvents $index 35 1 0 "centr"
#   launch_job "Psi_prime" $nEvents $index 35 1 1 "centr"
# 
#   launch_job "Psi_prime" $nEvents $index 15 0 1 "mbias"
#   launch_job "Psi_prime" $nEvents $index 15 1 0 "mbias"
#   launch_job "Psi_prime" $nEvents $index 15 1 1 "mbias"
#   
#   launch_job "Psi_prime" $nEvents $index 25 0 1 "mbias"
#   launch_job "Psi_prime" $nEvents $index 25 1 0 "mbias"
#   launch_job "Psi_prime" $nEvents $index 25 1 1 "mbias"
#   
#   launch_job "Psi_prime" $nEvents $index 35 0 1 "mbias"
#   launch_job "Psi_prime" $nEvents $index 35 1 0 "mbias"
#   launch_job "Psi_prime" $nEvents $index 35 1 1 "mbias"
