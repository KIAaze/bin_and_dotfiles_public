#!/bin/bash
PPM = $(ls *.ppm)
for IMAGE in PPM;
BMP=$(echo $IMAGE | awk -F '.' '{print $1}')
do ppmtobmp $IMAGE > $BMP;
done
