#!/bin/bash
set -eux
ffmpeg -i $1 -vf "transpose=2,transpose=2" ${1%.mp4}.90.mp4
