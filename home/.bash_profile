# ~/.bash_profile
# set -x
echo "reading .bash_profile"

source /etc/profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

xbindkeys
# User specific environment and startup programs
#if [ -f ~/.bash_env ]; then
#	. ~/.bash_env
#fi

# echo $PATH
# PATH=$PATH:$HOME/bin
# echo $PATH

# export PATH

# unset USERNAME
