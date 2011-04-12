#!/bin/bash

set -e -x

./build-nglib.sh
qmake
make
