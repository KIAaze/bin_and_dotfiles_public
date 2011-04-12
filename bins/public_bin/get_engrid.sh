#!/bin/bash

set -e -x

# mkdir engrid
# cd engrid
# cvs co src manual
# cd src
# ./build-nglib.sh
# qmake
# make

git clone ssh://$HOST_SF/srv/www/htdocs/git/engrid_src.git
git clone ssh://$HOST_SF/srv/www/htdocs/git/engrid_manual.git

cd engrid_src
./build-nglib.sh
qmake
make
