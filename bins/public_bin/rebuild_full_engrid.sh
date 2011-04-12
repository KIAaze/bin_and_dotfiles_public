#!/bin/bash
set -eux

cd netgen_svn/
qmake
make distclean
qmake
ssh node-003 "cd $PWD && source ~/.bash_profile  && make -j4"

cd ..

qmake
make distclean
qmake
ssh node-003 "cd $PWD && source ~/.bash_profile  && make -j4 debug"

~/bin/totalnotify.sh "SUCCESS"
