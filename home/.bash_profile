# ~/.bash_profile
# set -x
echo "reading .bash_profile"

source /etc/profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi

if [ -f /usr/bin/xbindkeys ]; then
  /usr/bin/xbindkeys
fi

if [ -f ~/.bash_profile_local ]; then
  source ~/.bash_profile_local
fi

# User specific environment and startup programs
#if [ -f ~/.bash_env ]; then
#	. ~/.bash_env
#fi

# echo $PATH
# PATH=$PATH:$HOME/bin
# echo $PATH

# export PATH

# unset USERNAME
