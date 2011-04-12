#!/bin/bash

set -e -x

mkdir engrid
cd engrid
cvs co src manual
cd src
#./build-nglib.sh
