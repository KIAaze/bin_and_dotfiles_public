# ~/.bash_profile
#echo "reading .bash_profile"

if [ -f /etc/profile ]; then
  source /etc/profile
fi

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# for non-synced stuff (machine specific welcome messages for example)
if [ -f ~/.bash_profile_local ]; then
  source ~/.bash_profile_local
fi
