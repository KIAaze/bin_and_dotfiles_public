# ${HOME}/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# echo "reading .bashrc"
# echo $PATH

# Source global definitions
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

# Environment variables
if [ -f ${HOME}/.bash_env_public ]; then
  source ${HOME}/.bash_env_public
fi

if [ -f ${HOME}/.bash_env_private ]; then
  source ${HOME}/.bash_env_private
fi

# Local stuff (i.e. not synced across PCs)
if [ -f ${HOME}/.bash_local ]; then
  source ${HOME}/.bash_local
fi

##################
# SHELL OPTIONS
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

# HISTIGNORE
#   A colon-separated list of patterns used to decide which command lines should be saved on the history list.
#   Each pattern is anchored at the beginning of the line and must match the complete line (no implicit `*' is appended).
#   Each pattern is tested against  the  line  after  the  checks  specified by HISTCONTROL are applied.
#   In addition to the normal shell pattern matching characters, `&' matches the previous history line.
#   `&' may be escaped using a backslash; the backslash is removed before attempting a match.
#   The second and subsequent lines of a multi-line compound command are not tested, and are added to the history regardless of the value of HISTIGNORE.
#   The pattern matching honors the setting of the extglob shell option.
# HISTSIZE
#   The number of commands to remember in the command history (see HISTORY below).  If the value is 0, commands are not saved in the history list.
#   Numeric values less than zero result in every command being saved  on  the  history  list  (there  is  no limit).
#   The shell sets the default value to 500 after reading any startup files.
# HISTFILESIZE
#   The maximum number of lines contained in the history file.
#   When this variable is assigned a value, the history file is truncated, if necessary, to contain no more than that number of lines by removing the oldest entries.
#   The history file  is  also truncated  to  this size after writing it when a shell exits.
#   If the value is 0, the history file is truncated to zero size.
#   Non-numeric values and numeric values less than zero inhibit truncation.
#   The shell sets the default value to the value of HISTSIZE after reading any startup files.

# hack for infinite bash history (but it still only saves the last HISTSIZE commands from the currently running shell)
# normally unsetting HISTFILESIZE should be enough, but for some strange reason bash keeps resetting it after finishing reading all the ${HOME}/.bash* files.

if ((${BASH_VERSINFO[0]} >= 4)) && ((${BASH_VERSINFO[1]} > 3))
then
  # bash version > 4.3
  export HISTSIZE=-1
  export HISTFILESIZE=-1
else
  # bash version <= 4.3
  export HISTSIZE=1000
  if [ -f ${HOME}/.bash_history ]; then
    export HISTFILESIZE=$(expr $(wc -l ${HOME}/.bash_history | awk '{print $1}') + ${HISTSIZE})
  else
    export HISTFILESIZE=${HISTSIZE}
  fi
fi

################
# MISC
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
# FUNCTIONS
##################
# echo '=====>bash_functions'
if [ -f ${HOME}/.bash_functions ]; then
    source ${HOME}/.bash_functions
fi
##########################################################

##################
# ALIASES
##################
# Alias definitions.
# You may want to put all your additions into a separate file like
# ${HOME}/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# echo '=====>bash_aliases'
if [ -f ${HOME}/.bash_aliases ]; then
    source ${HOME}/.bash_aliases
fi
##########################################################

##################
# PROMPT
##################
if [ -f ${HOME}/.bash_prompt ]; then
    source ${HOME}/.bash_prompt
fi

##########################################
# export GUILE_WARN_DEPRECATED=no
# unset USERNAME
# Version 0.84, configure options: '--prefix=/cm/shared/apps/mpiexec/0.84_432' '--with-default-comm=mpich-p4' '--with-pbs=/cm/shared/apps/torque/current'
# Version 0.84, configure options: '--prefix=/cm/shared/tools/MPIExec-0.84' '--with-default-comm=mpich2-pmi'

##########################################
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
#    if [ -e "${HOME}/agent.sh" ]; then
#       # remove the old file
#       rm -f ${HOME}/agent.sh
#    fi;
#    # start a new agent
#    exec ssh-agent | grep -v echo >&${HOME}/agent.sh
# fi;
# 
# test -e ${HOME}/agent.sh && source ${HOME}/agent.sh
# 
# alias kagent="kill -9 $SSH_AGENT_PID"
##########################################

if test -f ${HOME}/.dir_colors
then
	eval $(dircolors ${HOME}/.dir_colors)
fi

# set editing mode
#set -o vi
#set -o emacs

### vi editing mode tips:
# switch to command mode: ESC
# switch to insert mode: i
# start vi editor: v
## For more info:
# http://www.catonmat.net/blog/bash-vi-editing-mode-cheat-sheet/
# man 3 readline

GPG_TTY=$(tty)
export GPG_TTY

if [ -f /usr/bin/xbindkeys ] && [ -f ${HOME}/.xbindkeysrc ]; then
  /usr/bin/xbindkeys
fi

# Disallow write access to your terminal. (disabled by default, but just in case...)
# causes error on login in KDE4 however ("error found when loading ~/.profile:\n\nstdin: is not a tty\n as a result the session will not be configured correctly.")
#mesg n

# a quick and dirty fix for yakuake’s “open new tab in same directory” issue
# cf: https://acidbourbon.wordpress.com/2016/12/03/a-quick-and-dirty-fix-for-yakuakes-open-new-tab-in-same-directory-issue/
if [ $(basename "/"$(ps -f -p $(cat /proc/$(echo $$)/stat | cut -d \  -f 4) | tail -1 | sed 's/^.* //')) == "yakuake" ]; then
  # go to last active cwd
  if [ -e /dev/shm/$USER-yakuake-cwd ]; then
    cd "$(cat /dev/shm/$USER-yakuake-cwd)"
  fi
  # on each stroke of the return key, save cwd in a shared memory
  export PS1=$PS1'$(pwd > /dev/shm/$USER-yakuake-cwd)'
fi
