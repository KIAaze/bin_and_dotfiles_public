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

cd /s/$USER_flast/data
for (( i = $2 ; i <= $3 ; i++ ))
	do
	
        filename=`filename_generator "noJpsi.auau.25gev.centr.mc." $i ".root"`
        if [ ! -f $filename ];
	then
		echo "$filename does not exist.";
		echo "index=$i: creating job_0_$i";
		bsub -J job_0_$i -u $EMAIL_GSI /misc/cbmsoft/Debian3.1/tools/root/bin/root -l -q .x "~/cbmroot/macro/much/much_sim.C($1,$i,0)";
	fi
	
        filename=`filename_generator "Jpsi.auau.25gev.centr.mc." $i ".root"`
	if [ ! -f $filename ];
	then
		echo "$filename does not exist.";
		echo "index=$i: creating job_1_$i";
		bsub -J job_1_$i -u $EMAIL_GSI /misc/cbmsoft/Debian3.1/tools/root/bin/root -l -q .x "~/cbmroot/macro/much/much_sim.C($1,$i,1)";
	fi

done
