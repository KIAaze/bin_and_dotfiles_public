#!/bin/bash
myfunc()
{
  N=$(cat /dev/stdin)
  if [ $N -gt 0 ]
  then
    echo "$N"
    myfunc $(expr $N - 1) #| xargs myfunc
  fi
}

echo 10 | myfunc
# myfunc -10
# myfunc 0
# echo < /dev/stdin
# myfunc $(cat /dev/stdin)
