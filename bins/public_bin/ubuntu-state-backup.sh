#!/bin/bash
# cf: https://askubuntu.com/questions/9135/how-to-backup-settings-and-list-of-installed-packages

set -eux

DSTDIR=${1}

mkdir --parents "${DSTDIR}"

echo "Created using $(readlink -f ${0})" > ${DSTDIR}/README.txt

SYSINFOFILE="${DSTDIR}/system-info.log"

lsb_release -a &> "${SYSINFOFILE}"
echo "-----" &>> "${SYSINFOFILE}"
uname -a &>> "${SYSINFOFILE}"
echo "-----" &>> "${SYSINFOFILE}"
df -h &>> "${SYSINFOFILE}"
echo "-----" &>> "${SYSINFOFILE}"
sudo fdisk -l &>> "${SYSINFOFILE}"

dpkg --list > ${DSTDIR}/dpkg.log
dpkg --get-selections > ${DSTDIR}/Package.list
mkdir --parents ${DSTDIR}/etc.apt/
cp --recursive --verbose /etc/apt/sources.list* ${DSTDIR}/etc.apt/
apt-key exportall > ${DSTDIR}/Repo.keys

apt-clone clone ${DSTDIR}/apt-clone-state-ubuntu-$(lsb_release -sr)-$(date +%F).tar.gz &> ${DSTDIR}/apt-clone.log

# other config files
cp --verbose /etc/grub.d/10_linux ${DSTDIR}/
cp --verbose /etc/update-manager/release-upgrades ${DSTDIR}/

echo SUCCESS
