#This shellscript does the transport with and without Jpsi for arg1 events with index varying from arg2 to arg3
#But only in case the corresponding output files don't exist yet.

# Check if all parameters are present
# If no, exit
if [ $# -ne 3 ]
then
	echo
	echo 'usage :'
	echo 'transport.sh nEvents start_index end_index'
	echo
	exit 0 
fi

# Create joblist.txt and check if connected to an lxi machine
# If no, exit
cd /s/$USER_flast/data_Jpsi
bjobs>joblist.txt
if [ $? -eq 0 ]
then
  echo "already connected to an lxi machine"
  echo "joblist.txt creation successful"
else
  echo "not connected to an lxi machine"
  echo "joblist.txt creation not successful"
  exit 0
fi

#create jobs
cd /s/$USER_flast/data_Jpsi
for (( i = $2 ; i <= $3 ; i++ ))
	do
        
        filename1=`filename_generator "noPluto.Urqmd.auau.25gev.centr.mc." $i ".root"`
        filename2=`filename_generator "noPluto.Urqmd.auau.25gev.centr.params." $i ".root"`
        if [ ! -f $filename1 -o ! -f $filename2 ];
	then
		echo "$filename1 or $filename2 do not exist.";
		echo "index=$i: creating Jpsi_SIM_01_$i";
		bsub -J Jpsi_SIM_01_$i root -l -q .x "~/cbmroot/macro/much/much_sim_Jpsi.C($1,$i,0,1)";
	fi
	
        filename1=`filename_generator "Pluto.noUrqmd.auau.25gev.centr.mc." $i ".root"`
        filename2=`filename_generator "Pluto.noUrqmd.auau.25gev.centr.params." $i ".root"`
	if [ ! -f $filename1 -o ! -f $filename2 ];
	then
		echo "$filename1 or $filename2 do not exist.";
		echo "index=$i: creating Jpsi_SIM_10_$i";
		bsub -J Jpsi_SIM_10_$i root -l -q .x "~/cbmroot/macro/much/much_sim_Jpsi.C($1,$i,1,0)";
	fi
        
        filename1=`filename_generator "Pluto.Urqmd.auau.25gev.centr.mc." $i ".root"`
        filename2=`filename_generator "Pluto.Urqmd.auau.25gev.centr.params." $i ".root"`
        if [ ! -f $filename1 -o ! -f $filename2 ];
	then
		echo "$filename1 or $filename2 do not exist.";
		echo "index=$i: creating Jpsi_SIM_11_$i";
		bsub -J Jpsi_SIM_11_$i root -l -q .x "~/cbmroot/macro/much/much_sim_Jpsi.C($1,$i,1,1)";
	fi

done
