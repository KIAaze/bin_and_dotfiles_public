#!/bin/bash
set -eu
sed '/^\s*%/d' ${1} > ${1%.tex}.cleaned.1.tex
sed '/^\s*%/d' ${1} | sed 's/^\s\+$//' > ${1%.tex}.cleaned.2.tex
sed '/^\s*%/d' ${1} | sed 's/^\s\+$//' | cat -s > ${1%.tex}.cleaned.3.tex
