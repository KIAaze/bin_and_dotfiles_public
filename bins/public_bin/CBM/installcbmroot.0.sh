echo "INSTALLING ROOT:"
cd ~
svn  co  https://subversion.gsi.de/fairroot/cbmroot
. /misc/cbmsoft/config/CbmEnv.sh new
mkdir MyBuild_32
cd cbmroot
./reconf
cd ~/MyBuild_32
~/cbmroot/configure  --prefix=$PWD --enable-geant3  
. ./config.sh
make
make install
echo
echo "COPYING NECESSARY FILES WITHOUT OVERWRITING:"
mkdir ~/cbmroot/macro/run/data
#false | cp -irv /misc/kisselan/cbmroot/input/* ~/cbmroot/input; echo
#false | cp -irv /misc/kisselan/cbmroot2/geometry/* ~/cbmroot/input; echo
false | cp -irv /misc/kisselan/cbmroot/* ~/cbmroot; echo
false | cp -irv /misc/kisselan/cbmroot2/* ~/cbmroot; echo
echo
#echo "ADAPTING MUCH_SIM.C:"
#cd ~
#(awk -f awksed.awk /d/cbm01/cbmsim/urqmd/ /d/cbm03/urqmd/ ~/cbmroot/macro/much/much_sim.C)>temp
#(awk -f awksed.awk /misc/kisselan/cbmroot2/macro/pluto/Jpsi/Jpsi_0.root /misc/kisselan/cbmroot2/macro/pluto/Jpsi/15gev/Jpsi_0000.root temp)>~/cbmroot/macro/much/much_sim.C
echo "REPLACING MAIN FILES WITH THOSE FROM SVN_WORKING_MACROS SO THAT THEY WORK..."
cp -rv ~/svn_working_macros/* ~/cbmroot/macro
echo
echo "INSTALLATION FINISHED."
echo
echo "RUNNING MAIN MACROS TO CHECK THAT THEY WORK:"
cd ~/cbmroot/run
rootdbg.sh run
rootdbg.sh run_sim
rootdbg.sh run_reco
cd ~/cbmroot/sts
rootdbg.sh sts_sim
rootdbg.sh sts_reco
cd ~/cbmroot/much
rootdbg.sh much_sim
rootdbg.sh sts_reco
rootdbg.sh much_reco
echo
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
