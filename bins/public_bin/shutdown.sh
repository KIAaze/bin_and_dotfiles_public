#! /bin/bash
set -eu

# shutdown wrapper, which only schedules a new shutdown if no other one is scheduled already (like the old shutdown command)
# sudo shutdown -c
# sudo halt

if [[ $1 = '-c' ]]
then
  shutdown "${@}"
fi

if shutdown-info.sh
then
#   echo "A shutdown is already scheduled. You can cancel it with shutdown -c"
  exit 1
else
  shutdown "${@}"
fi
