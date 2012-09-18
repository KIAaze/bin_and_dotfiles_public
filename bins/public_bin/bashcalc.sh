#!/bin/bash
# see also expr: "expr 2 + 2"
echo "scale=4; $1" | bc ;exit
