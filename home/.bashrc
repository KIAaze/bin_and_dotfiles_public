# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#~ echo "reading .bashrc"

# echo $PATH

# Source global definitions
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

# echo $PATH

# User specific aliases and functions
if [ -f $HOME/.bash_env_public ]; then
  source $HOME/.bash_env_public
fi
if [ -f $HOME/.bash_env_private ]; then
  source $HOME/.bash_env_private
fi

# Local stuff (i.e. not synced across PCs)
if [ -f $HOME/.bash_local ]; then
  source $HOME/.bash_local
fi

##################
#BASH
##################

# option that auto corrects the case for you
# shopt -s nocaseglob
# Makes sure that histories in multiple simultaneous shells don’t overwrite each other.
shopt -s histappend
# Corrects typos in your file/directory name.
# shopt -s cdspell

# make sure that bash does not store any command beginning with the space character
# export HISTCONTROL=ignorespace

# don't put duplicate lines in the history. See bash(1) for more options
#ignoredups checks the old history, erasedups checks the current history, not yet written to HISTFILE
export HISTCONTROL=ignoredups:erasedups

# hack for infinite bash history (but it still only saves the last HISTSIZE commands from the currently running shell)
# normally unsetting HISTFILESIZE should be enough, but for some strange reason bash keeps resetting it after finishing reading all the ~/.bash* files.
export HISTSIZE=1000
export HISTFILESIZE=$(expr $(wc -l $HOME/.bash_history | awk '{print $1}') + $HISTSIZE)

################
#OTHER
################

#display a short random fortune :)
#fortune -s

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

#stop the beep
#xset -b

#to stay in the directory visited with mc on exit. :)
# echo '=====>mc.sh'
if [ -f /usr/share/mc/bin/mc.sh ]; then
  source /usr/share/mc/bin/mc.sh
fi

##########################################################

##################
#FUNCTIONS
##################
# echo '=====>bash_functions'
if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi
##########################################################

##################
#ALIASES
##################
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# echo '=====>bash_aliases'
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi
##########################################################

##################
#PROMPT
##################
if [ -f ~/.bash_prompt ]; then
    source ~/.bash_prompt
fi
##########################################################

# Modules for working on BC
if declare -f module >/dev/null
then
	module load apps/meep-1.2-mpi 2>/dev/null
	module add shared torque moab 2>/dev/null
	module load libraries/gnu_builds/atlas-3.10.1 2>/dev/null
	module load libraries/gnu_builds/gsl-1.16 2>/dev/null
	
	# load most recent matlab
    if ! module load matlab-R2014a-x86_64 2>/dev/null
    then
      module load apps/matlab-r2013b 2>/dev/null
    fi

#	module add shared torque moab 2>/dev/null
#	module add languages/python-2.7 2>/dev/null
#	module add apps/matlab-R2009a 2>/dev/null
#	module load apps/meep-mpi 2>/dev/null
#	module load meep-mpi 2>/dev/null
#	module load gnu_builds/hdf5.mpi 2>/dev/null
#	module load gnu_builds/h5utils 2>/dev/null
#	module load gnu_builds/gsl-1.13 2>/dev/null
#	module load gnu_builds/gsl 2>/dev/null
#	module load languages/fpc-2.4.0 2>/dev/null
#	module load apps/paraview-3.8 2>/dev/null
#	module load languages/python-2.7.2 2>/dev/null
#	module load tools/git-1.7.9 2>/dev/null
	module load languages/python-3.3.2 2>/dev/null
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# echo '=====>/etc/bash_completion'
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

##########################################
# from http://drupal.star.bnl.gov/STAR/blog-entry/jeromel/2009/feb/06/how-safely-start-ssh-agent-bashrc
# safely start ssh agent
# TESTAGENT=`/bin/ps -ef | grep ssh-agent | grep -v grep  | awk '{print $2}' | xargs`
# 
# if [ "$TESTAGENT" = "" ]; then
#    # there is no agent running
#    if [ -e "$HOME/agent.sh" ]; then
#       # remove the old file
#       rm -f $HOME/agent.sh
#    fi;
#    # start a new agent
#    exec ssh-agent | grep -v echo >&$HOME/agent.sh
# fi;
# 
# test -e $HOME/agent.sh && source $HOME/agent.sh
# 
# alias kagent="kill -9 $SSH_AGENT_PID"
##########################################

if test -f $HOME/.dir_colors
then
	eval $(dircolors $HOME/.dir_colors)
fi

# set vi editing mode
set -o vi

### vi editing mode tips:
# switch to command mode: ESC
# switch to insert mode: i
# start vi editor: v
## For more info:
# http://www.catonmat.net/blog/bash-vi-editing-mode-cheat-sheet/
# man 3 readline

GPG_TTY=$(tty)
export GPG_TTY
