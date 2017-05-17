#!/bin/bash

# compresses a directory to a .tar.bz2 archive and remove files after adding them to the archive

for DIR in "$@"
do
    ABSDIR=$(readlink -f ${DIR})
	ARCHIVE="$(dirname ${ABSDIR})/$(basename ${ABSDIR}).tar.bz2"
	echo "Compress ${ABSDIR} to ${ARCHIVE} ? (y/n/q)"
	read ans
	case ${ans} in
		y|Y|yes) echo "Compressing..."
			tar --create --bzip2 --verbose --remove-files --file ${ARCHIVE} --directory $(dirname ${ABSDIR}) $(basename ${ABSDIR});;
		q) exit;;
		*) echo "Skipping ${DIR}";;
	esac
done
