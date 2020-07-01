#!/bin/bash
set -eu

echo "=== diff -rq ${1} ${2} ==="
diff -rq "${1}" "${2}"
echo "Press any key to continue"
read ans

echo "=== fdupes -r ${1} ==="
fdupes -r "${1}"
echo "Press any key to continue"
read ans

echo "=== fdupes -r ${2} ==="
fdupes -r "${2}"
echo "Press any key to continue"
read ans

echo "=== fdupes -r ${1} ${2} ==="
fdupes -r "${1}" "${2}"
echo "Press any key to continue"
read ans

echo "=== fdupes -rdN ${1} ${2} ==="
echo "run?"
read ans
case $ans in
  y|Y|yes) fdupes -rdN "${1}" "${2}";;
esac

echo "=== cleanup ==="
echo "cleanup?"
read ans
case $ans in
  y|Y|yes) removeEmptyDirectories.py "${2}"
           rmdir "${2}";;
esac
