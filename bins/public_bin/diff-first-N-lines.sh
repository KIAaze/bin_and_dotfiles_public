#!/bin/bash

# cf: https://superuser.com/questions/511396/how-to-diff-only-the-first-line-of-two-files

fileOne=${1}
fileTwo=${2}
numLines=${3}

diff <(head -n ${numLines} ${fileOne}) <(head -n ${numLines} ${fileTwo})
