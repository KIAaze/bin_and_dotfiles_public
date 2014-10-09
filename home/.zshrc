##########################################################

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=1000
setopt appendhistory notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

####
# To run zsh-newuser-install again:
# The function will not be run in future, but you can run
# it yourself as follows:
#   autoload -Uz zsh-newuser-install
#   zsh-newuser-install -f
# 
# The code added to ~/.zshrc is marked by the lines
# # Lines configured by zsh-newuser-install
# # End of lines configured by zsh-newuser-install
# You should not edit anything between these lines if you intend to
# run zsh-newuser-install again.  You may, however, edit any other part
# of the file.

setopt histexpiredupsfirst
setopt HIST_REDUCE_BLANKS
setopt INTERACTIVE_COMMENTS
autoload -Uz add-zsh-hook
bindkey '^R' history-incremental-search-backward
autoload -U colors && colors
autoload -Uz promptinit
promptinit
# prompt fire
# prompt adam2
prompt suse

# ##########################################################
if [ -f ~/.zsh_env ]; then
  source ~/.zsh_env
fi
# DISABLING ALL TO SEE IF MESSED UP HISTORY PROBLEM STILL OCCURS.
# # Source global definitions
# if [ -f /etc/zsh/zshrc ]; then
#   source /etc/zsh/zshrc
# fi
# 
# if [ -f ~/.bash_env ]; then
#   source ~/.bash_env
# fi
# 
# Local stuff (i.e. not synced across PCs)
if [ -f ~/.bash_local ]; then
  source ~/.bash_local
fi
# 
# if [ -f ~/.bash_functions ]; then
#     source ~/.bash_functions
# fi
# 
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi
# 
# # TODO: Finish adapting. Leads to weird stuff at the moment.
# # if [ -f ~/.zsh_prompt ]; then
# #     source ~/.zsh_prompt
# # fi
# 
# #to stay in the directory visited with mc on exit. :)
# if [ -f /usr/share/mc/bin/mc.sh ]; then
#   source /usr/share/mc/bin/mc.sh
# fi
