#!/bin/sh
##### Script to replace symbolic links with their target files.
##### Adapted from grawity's script: https://superuser.com/questions/303559/replace-symbolic-links-with-files
##### Using the method suggested by Mr Fooz to handle symlink failures by copying targets to temporary files, before replacing the symlink.
#####
##### Usage:
#####   ReplaceSymLink.sh LINK1 LINK2 ...
#####
##### Find and replace all symlinks in a directory:
#####   find . -type l -exec ReplaceSymLink.sh {} \;
set -e

for LINK; do
    test -h "${LINK}" || continue # skip any files passed that are not symbolic links

    LINKDIR=$(dirname "${LINK}")
    LINKBASE=$(basename "${LINK}")
    RELTARGET=$(readlink "${LINK}")

    if ! test -e "${LINK}"
    then
      # echo "SKIPPING: Broken symbolic link: ${LINK} -> ${RELTARGET}"
      continue
    fi

    ABSTARGET=$(readlink --canonicalize "${LINK}")

    # echo "${LINK} -> ${RELTARGET} -> ${ABSTARGET}"
    if test -d "${LINK}"
    then
      TMPDIR=$(mktemp --directory --tmpdir="${LINKDIR}" "${LINKBASE}.XXX")
      echo "====> directory: ${LINK} -> ${RELTARGET} -> ${ABSTARGET}, using TMPDIR: ${TMPDIR}"
      # echo "${LINK}: directory -> ${TMPDIR}"
      cp --archive --verbose --no-target-directory "${ABSTARGET}" "${TMPDIR}"
      rm --verbose "${LINK}"
      mv --verbose "${TMPDIR}" "${LINK}"
    else
      TMPFILE=$(mktemp --tmpdir="${LINKDIR}" "${LINKBASE}.XXX")
      echo "====> file: ${LINK} -> ${RELTARGET} -> ${ABSTARGET}, using TMPFILE: ${TMPFILE}"
      # echo "${LINK}: file -> ${TMPFILE}"
      cp --archive --verbose --no-target-directory "${ABSTARGET}" "${TMPFILE}"
      mv --verbose "${TMPFILE}" "${LINK}"
    fi
done
