#! /bin/bash
# daemon to kill the most memory intensive user process

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
        echo
        echo "usage :"
        echo "$0 min_mem"
	echo "This shellscript will kill the most memory intensive user process if the free RAM goes beneath min_mem."
        echo
        exit 0
fi

#example output of free
#              total       used       free     shared    buffers     cached
# Mem:        450300     420636      29664          0      25172     234092
# -/+ buffers/cache:     161372     288928
# Swap:            0          0          0

while true
do
	sleep 1

# 	Mem:=free | grep 'Mem:' |  awk '{print $1 }'
# 	total=free | grep 'Mem:' |  awk '{print $2 }'
# 	used=free | grep 'Mem:' |  awk '{print $3 }'
	freemem_1=$(free | grep 'Mem:' |  awk '{print $4 }')
# 	shared=free | grep 'Mem:' |  awk '{print $5 }'
# 	buffers=free | grep 'Mem:' |  awk '{print $6 }'
# 	cached=free | grep 'Mem:' |  awk '{print $7 }'
	
# 	-/+=free | grep 'buffers/cache:' |  awk '{print $1 }'
# 	buffers/cache:=free | grep 'buffers/cache:' |  awk '{print $2 }'
# 	used=free | grep 'buffers/cache:' |  awk '{print $3 }'
	freemem_2=$(free | grep 'buffers/cache:' |  awk '{print $4 }')

#	freemem=$(cat /proc/meminfo | head -2 | tail -1 | awk '{print $2 }')
	freemem=$freemem_2;
# 	echo "$freemem_1" >>mem_1.log
# 	echo "$freemem_2" >>mem_2.log

	if test $freemem -lt $1
	then
		echo "=========================" >>memwatch.log
		echo "freemem=$freemem < $1" >>memwatch.log
		~/bin/killmaxmemprocess.sh 1
	fi
done
