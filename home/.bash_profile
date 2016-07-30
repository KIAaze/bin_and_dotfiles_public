# ${HOME}/.bash_profile
#echo "reading .bash_profile"

if [ -f /etc/profile ]; then
  source /etc/profile
fi

if [ -f ${HOME}/.bashrc ]; then
  source ${HOME}/.bashrc
fi

# for non-synced stuff (machine specific welcome messages for example)
if [ -f ${HOME}/.bash_profile_local ]; then
  source ${HOME}/.bash_profile_local
fi
