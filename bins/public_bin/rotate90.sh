#!/bin/bash
set -eux
ffmpeg -i $1 -vf "transpose=1" ${1%.mp4}.90.mp4
