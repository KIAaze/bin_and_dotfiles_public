# ~/.bash_profile
# set -x
echo "reading .bash_profile"

source /etc/profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
#if [ -f ~/.bash_env ]; then
#	. ~/.bash_env
#fi

PATH=$PATH:$HOME/bin

export PATH
unset USERNAME
