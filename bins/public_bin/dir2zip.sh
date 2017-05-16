#!/bin/bash

# compresses a directory to a .tar.bz2 archive and remove files after adding them to the archive

for DIR in "$@"
do
	ARCHIVE=$(basename ${DIR}).tar.bz2
	echo "Compress ${DIR} to ${ARCHIVE} ? (y/n/q)"
	read ans
	case ${ans} in
		y|Y|yes) echo "Compressing..."
			tar --create --bzip2 --verbose --remove-files --file ${ARCHIVE} ${DIR};;
		q) exit;;
		*) echo "Skipping ${DIR}";;
	esac
done
