#! /bin/bash

###Constants
#note: It's important to add the "~", otherwise there might be logfiles created in the wrong directories. ;)
LOGFILE=~/cbmroot_installation.log ;

###Functions

quitting()
{
  echo "NO" >>$LOGFILE;
  echo "Bye";
  echo "Installation info logged in $LOGFILE";
  exit 0;
}

installcbmroot()
{
  echo "Installing CBMroot..."
    
    echo "INSTALLING CBMROOT:"
    cd ~
    svn  co  https://subversion.gsi.de/fairroot/cbmroot
    . /misc/cbmsoft/config/CbmEnv.sh new
    mkdir MyBuild_32
    cd cbmroot
    ./reconf
    cd ~/MyBuild_32
  
  cmake ../cbmroot
  #~/cbmroot/configure  --prefix=$PWD --enable-geant3  
    
    . ./config.sh
    make
    make install
  
  echo "CBMroot installed."
}

copy_cbmroot2()
{
  echo "Copying files..."
  
    echo
    echo "COPYING NECESSARY FILES WITHOUT OVERWRITING:"
    false | cp -irv /misc/kisselan/cbmroot2/input/* ~/cbmroot/input; echo
    false | cp -irv /misc/kisselan/cbmroot2/geometry/* ~/cbmroot/geometry; echo
  #  false | cp -irv /misc/kisselan/cbmroot/* ~/cbmroot; echo
  #  false | cp -irv /misc/kisselan/cbmroot2/* ~/cbmroot; echo
    echo
  
  echo "Files copied."
}

replace_files()
{
  echo "Replacing files..."
  
  #echo "ADAPTING MUCH_SIM.C:"
  #cd ~
  #(awk -f awksed.awk /d/cbm01/cbmsim/urqmd/ /d/cbm03/urqmd/ ~/cbmroot/macro/much/much_sim.C)>temp
  #(awk -f awksed.awk /misc/kisselan/cbmroot2/macro/pluto/Jpsi/Jpsi_0.root /misc/kisselan/cbmroot2/macro/pluto/Jpsi/15gev/Jpsi_0000.root temp)>~/cbmroot/macro/much/much_sim.C
    echo "REPLACING MAIN FILES WITH THOSE FROM SVN_WORKING_MACROS SO THAT THEY WORK..."
    cp -rv ~/svn_working_macros/* ~/cbmroot/macro
    echo
    echo "INSTALLATION FINISHED."
    echo
  
  echo "Files replaced."
}

test_macros()
{
  echo "Running main macros..."
    
    echo "CHECKING PROCESSOR CAPABILITIES"
    has_sse.sh
    if [ $? -eq 0 ]
    then
      echo "RUNNING MAIN MACROS TO CHECK THAT THEY WORK:"
      mkdir ~/cbmroot/macro/run/data
      cd ~/cbmroot/macro/run
      rootdbg.sh run.C
      rootdbg.sh run_sim.C
      rootdbg.sh run_reco.C
      cd ~/cbmroot/macro/sts
      rootdbg.sh sts_sim.C
      rootdbg.sh sts_reco.C
      cd ~/cbmroot/macro/much
      rootdbg.sh much_sim.C
      rootdbg.sh sts_reco.C
      rootdbg.sh much_reco.C
      echo
      echo "STDOUT LOGS:"
      echo "~/cbmroot/macro/run/run.out"
      echo "~/cbmroot/macro/run/run_sim.out"
      echo "~/cbmroot/macro/run/run_reco.out"
      echo "~/cbmroot/macro/sts/sts_sim.out"
      echo "~/cbmroot/macro/sts/sts_reco.out"
      echo "~/cbmroot/macro/much/much_sim.out"
      echo "~/cbmroot/macro/much/sts_reco.out"
      echo "~/cbmroot/macro/much/much_reco.out"
      echo "STDERR LOGS:"
      echo "~/cbmroot/macro/run/run.err"
      echo "~/cbmroot/macro/run/run_sim.err"
      echo "~/cbmroot/macro/run/run_reco.err"
      echo "~/cbmroot/macro/sts/sts_sim.err"
      echo "~/cbmroot/macro/sts/sts_reco.err"
      echo "~/cbmroot/macro/much/much_sim.err"
      echo "~/cbmroot/macro/much/sts_reco.err"
      echo "~/cbmroot/macro/much/much_reco.err"
      echo
    fi
        
  echo "Main macros run finished."
}

display_instructions()
{
  echo "Displaying instructions..."
    
    echo "HOW TO USE CBMROOT:"
    echo "Run the macros in this order:"
    echo
    echo "run/run.C"
    echo "run/run_sim.C"
    echo "run/run_reco.C"
    echo
    echo "sts/sts_sim.C"
    echo "sts/sts_reco.C"
    echo
    echo "much/much_sim.C"
    echo "much/sts_reco.C"
    echo "much/much_reco.C"
    echo
    echo "IMPORTANT: You must exit root after each one."
    echo "You may use ~/bin/rootdbg.sh to automate this. :)"
  
  echo "Instructions displayed"
}
##################################################################################################################
#remove old logfile
#rm $LOGFILE
#start logging
echo "================================">>$LOGFILE
date >>$LOGFILE
echo "================================">>$LOGFILE

##################################################################################################################
echo "WARNING:"
echo "This will install CBMroot."
echo "Do you wish to continue? (q to quit)"

echo "installcbmroot : " >>$LOGFILE;

read ans
case $ans in
  y|Y|yes) echo "YES" >>$LOGFILE;
           installcbmroot;;
  q) quitting;;
  *) echo "NO" >>$LOGFILE;
     echo "next step";;
esac

##################################################################################################################
echo "WARNING:"
echo "This will copy (without overwriting) all input and geometry files from /misc/kisselan/cbmroot2/ to ~/cbmroot"
echo "Do you wish to continue? (q to quit)"

echo "copy_cbmroot2 : " >>$LOGFILE;

read ans
case $ans in
  y|Y|yes) echo "YES" >>$LOGFILE;
           copy_cbmroot2;;
  q) quitting;;
  *) echo "NO" >>$LOGFILE;
     echo "next step";;
esac

##################################################################################################################
echo "WARNING:"
echo "This will replace main files with those from svn_working_macros."
echo "Do you wish to continue? (q to quit)"

echo "replace_files : " >>$LOGFILE;

read ans
case $ans in
  y|Y|yes) echo "YES" >>$LOGFILE;
           replace_files;;
  q) quitting;;
  *) echo "NO" >>$LOGFILE;
     echo "next step";;
esac

##################################################################################################################
echo "WARNING:"
echo "This will run the main macros to check that they work."
echo "Do you wish to continue? (q to quit)"

echo "test_macros : " >>$LOGFILE;

read ans
case $ans in
  y|Y|yes) echo "YES" >>$LOGFILE;
           test_macros;;
  q) quitting;;
  *) echo "NO" >>$LOGFILE;
     echo "next step";;
esac

##################################################################################################################
echo "WARNING:"
echo "This will display instructions on how to use CBMroot."
echo "Do you wish to continue? (q to quit)"

echo "display_instructions : " >>$LOGFILE;

read ans
case $ans in
  y|Y|yes) echo "YES" >>$LOGFILE;
           display_instructions;;
  q) quitting;;
  *) echo "NO" >>$LOGFILE;
     echo "next step";;
esac

##################################################################################################################
