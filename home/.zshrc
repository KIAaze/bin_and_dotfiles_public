# Lines configured by zsh-newuser-install
# HISTFILE=~/.histfile
# HISTSIZE=1000
# SAVEHIST=1000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
####################
##### https://unix.stackexchange.com/questions/273861/unlimited-history-in-zsh
##### https://zsh.sourceforge.io/Doc/Release/Parameters.html#index-SAVEHIST
##### Check options with "set -o"
##### https://unix.stackexchange.com/questions/121802/zsh-how-to-check-if-an-option-is-enabled

# HISTFILE="$HOME/.zsh_history"
HISTFILE=~/.histfile
HISTSIZE=10000000 # The maximum number of events stored in the internal history list.
SAVEHIST=10000000 # The maximum number of history events to save in the history file.

# setopt BANG_HIST                 # Treat the '!' character specially during expansion.
# setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
# setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
# setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
# setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
unsetopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
# setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
# setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
# setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
# setopt HIST_BEEP                 # Beep when accessing nonexistent history.
####################

# The following lines were added by compinstall

zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/mike/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#
#####################################################
##### to suggest packages for missing commands:
source /usr/share/doc/pkgfile/command-not-found.zsh

alias ls='ls --color'
alias lrt='ls -lrt'
alias ll='ls -l'
alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -iv'

# for comments in interactive mode!!!
setopt interactivecomments

PS1='%n@%m %~$ '

########## key bindings
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
# Set or display attributes and values for shell parameters.
# The -g (global) means that any resulting parameter will not be restricted to local scope.
# The names refer to associative array parameters; see Array Parameters in zshparam(1).
# https://github.zshell.dev/post/zsh/cheatsheet/typeset/
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
# With the -U flag, alias expansion is suppressed when the function is loaded.
# The flags -z and -k mark the function to be autoloaded using the zsh or ksh style, as if the option  KSH_AUTOLOAD  were
# unset or were set, respectively.  The flags override the setting of the option at the time the function is loaded.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# # print key values
# for mykey myval in "${(@kv)key}"; do
#     echo "$mykey -> $myval"
# done

##### PATH config
export PATH=${PATH}:${HOME}/bin
export PATH=${PATH}:${HOME}/.local/bin
export PATH=${PATH}:${HOME}/opt/bin
#export PATH=${PATH}:${HOME}/bin/private_bin
export PATH=${PATH}:${HOME}/Development/bin_and_dotfiles_public/bins/public_bin
export PATH=${PATH}:${HOME}/Development/bin_and_dotfiles_private/private_bin
export PATH=${PATH}:${HOME}/.venv/python3_user/bin/

# https://unix.stackexchange.com/questions/641238/how-to-make-a-glib-app-look-for-schema-at-a-different-path
export LD_LIBRARY_PATH=${HOME}/.local/lib:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=${HOME}/opt/lib:${LD_LIBRARY_PATH}
export GSETTINGS_SCHEMA_DIR="${HOME}/opt/share/glib-2.0/schemas:${GSETTINGS_SCHEMA_DIR}"
export XDG_DATA_DIRS="${HOME}/opt/share/:${XDG_DATA_DIRS}"

source ${HOME}/.bash_aliases
source ${HOME}/.bash_functions
source ${HOME}/.bash_env_private

######
### Pretty prompt:
# https://medium.com/@swindlers-inc/prettifying-my-zsh-prompt-e1fe04848005
# https://stackoverflow.com/questions/689765/how-can-i-change-the-color-of-my-prompt-in-zsh-different-from-normal-text
autoload -U colors && colors
PS1=$'%K{cyan}%F{black}\uF303[%n@%m] %~%F{cyan}%K{yellow}\uE0B0%F{black}%1v%k%F{yellow}\uE0B0%f '
