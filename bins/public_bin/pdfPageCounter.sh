#!/bin/bash
# cf:
# https://superuser.com/questions/403672/how-to-count-pages-in-multiple-pdf-files
# https://www.linuxquestions.org/questions/programming-9/how-to-find-pdf-page-count-699113/
# https://unix.stackexchange.com/questions/335716/grep-returns-binary-file-standard-input-matches-when-trying-to-find-a-string

for i in "${@}"
do
  NP=$(pdfinfo "${i}" | grep --text "^Pages:" | awk '{print $2}')
  NS=$(expr \( $NP + 1 \) / 2)
  echo "${i}: pages=${NP}, sheets=${NS}"
done

NP=$(for i in "${@}"; do pdfinfo "$i" | grep --text "^Pages:"; done | awk 'BEGIN {s=0} {s+=$2} END {print s}')
NS=$(expr \( $NP + 1 \) / 2)
echo "Total number of pages: ${NP}"
echo "Total number of sheets: ${NS}"
