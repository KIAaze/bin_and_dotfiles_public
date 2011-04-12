#!/bin/bash
echo "scale=2 ; $*" | sed -e "s:x:*:g" | sed -e "s:,::g" | bc

#function math
#{
#        echo "scale=2 ; $*" | sed -e "s:x:*:g" | sed -e "s:,::g" | bc
#}
