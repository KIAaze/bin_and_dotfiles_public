#!/bin/bash
mv_p()
{
   echo "mv with progress bar"
   echo  "${1}" "${2}"
   total_size=$(stat -c ‘%s’ "${1}")
   echo $total_size
   set -e
#   strace -q -ewrite mv -- "${1}" "${2}" 2>&1 \
cat "${1}" \
      | awk '{
	    count += $NF
            if (count % 10 == 0) {
		percent= count / total_size *100
               printf "%3d%% [", percent
               for (i=0;i<=percent;i++)
                  printf "="
               printf ">"
               for (i=percent;i<100;i++)
                  printf " "
               printf "]\r"
            }
         }
         END { print "" }' total_size=$(stat -c ‘%s’ "${1}") count=0 
}

mv_p $1 $2
