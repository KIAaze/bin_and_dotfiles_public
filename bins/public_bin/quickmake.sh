#!/bin/bash
set -eux
ssh node-003 "cd $PWD && source ~/.bash_profile  && make -j4 $*"
