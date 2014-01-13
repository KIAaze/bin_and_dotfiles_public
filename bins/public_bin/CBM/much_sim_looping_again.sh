#This shellscript runs much_sim.C(nEvents,index) with nEvents=arg1 and index varying from arg2 to arg3
#But only in case the corresponding output files don't exist yet.

# Check if all parameters are present
# If no, exit
if [ $# -ne 3 ]
then
	echo
	echo 'usage :'
	echo 'much_sim_looping_again.sh nEvents start_index end_index'
	echo
	exit 0 
fi

cd /s/$USER_flast/data
for (( i = $2 ; i <= $3 ; i++ ))
	do
	filename=`filename_generator "Jpsi.auau.25gev.centr.mc." $i ".root"`
	if [ ! -f $filename ];
	then
		echo "$filename does not exist.";
		echo "index=$i: creating job_$i"
		bsub -J job_$i -u $EMAIL_GSI root -l -q .x "~/cbmroot/macro/much/much_sim.C($1,$i)"
	fi
done
