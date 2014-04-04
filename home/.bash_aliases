#!/bin/bash
# ~/.bash_aliases
#echo "reading .bash_aliases"

##################
#ALIASES
##################

# OpenFOAM stuff
#alias source_openfoam='source $HOME/OpenFOAM/OpenFOAM-1.5/etc/bashrc'
#alias source_openfoam='source $HOME/OpenFOAM/OpenFOAM-1.4.1/.OpenFOAM-1.4.1/bashrc'
alias source_openfoam='source $HOME/OpenFOAM/OpenFOAM-1.6/etc/bashrc'

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias ls_noExeColor='ls_noExeColor --color=auto'
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'
fi

# ls aliases
# alias l='ls -CF'
alias la='ls -aA'
alias ll='ls -lhX'
alias laf='ls -laF'
alias lla='ll -a'
alias lrt='ls -lrt'
alias ldir='ls -lhA |grep ^d'
alias lfiles='ls -lhA |grep ^-'
alias lsdot='ls -ld \.[A-Za-z0-9]*'

# To see something coming into ls output: lss
alias lss='ls -lrt | grep $1'

# safety aliases for rm,mv,cp
alias rm='rm -iv'
alias mv='mv -iv'
alias cp='cp -iv' 

# check commands
alias checkcmd='totalnotify.sh "SUCCESS" || ( totalnotify.sh "FAILURE" && false )'
alias mailcmd='mailme "SUCCESS" || mailme "FAILURE" '

# CLI GPG-mailing (key to be used can be specified by using "gpg -u EMAIL...")
alias gpgmail='gpg -as | mail'

# other
alias datefull='date +%Y%m%d_%H%M%S'
alias pmake='make -j$(num_threads)'
# alias h='history'
alias rlogin='slogin -X'
alias astyle_all='astyle *.h *.cpp */*.h */*.cpp'
alias wc_all='wc -l *.h *.cpp */*.h */*.cpp | sort'

# to be able to use aliases under sudo
# updated based on http://www.reddit.com/r/linux/comments/13s57s/make_your_bashrc_aliases_work_with_sudo/
alias sudo='sudo '
#alias sudo='A=`alias` sudo  '

# rebuild aliases
alias rebuild_all='qmake && make distclean && qmake && make -j$(num_threads) debug release && checkcmd'
alias rebuild_debug='qmake && make distclean && qmake && make -j$(num_threads) debug && checkcmd'
alias rebuild_release='qmake && make distclean && qmake && make -j$(num_threads) release && checkcmd'

#alias git_log_month='echo $1'git log --after="$1 1 2009" --before="Jul 1 2009"
alias profile='valgrind --tool=callgrind --dump-instr=yes --simulate-cache=yes --collect-jumps=yes'
alias git_checkall='git pull && git push && git status'
alias bzr_checkall='bzr pull && bzr push && bzr status'

if [ -n "${RSYNCDIR}" ] && [ -n "${SYNCSTICK}" ]
then
  # using the multiple repository manager with a custom pullpush function :)
  alias mr_checkall='mr --directory ${HOME} --stats pullpush'
  alias mr_rsync='mr --config ${RSYNCDIR}/.mrconfig.rsync'
  alias mr_checkall_rsync='mr_rsync --directory ${RSYNCDIR} --stats status'

  # sync all, unmount USB stick and check it was unmounted
  alias goodbye='mr_checkall && mr_checkall_rsync && umount ${SYNCSTICK} && ( ! test -d ${SYNCSTICK} ) && checkcmd'
else
  echo "WARNING: RSYNCDIR or SYNCSTICK not defined."
fi

# plugin testing
# You must have the plugin stuff in a subdirectory named "designer" for this to work
alias test_plugin='export QT_PLUGIN_PATH=$(pwd); designer'

# To check a process is running in a box with a heavy load: pss
alias pss='ps -ef | grep $1'

# usefull alias to browse your filesystem for heavy usage quickly
# alias ducks='ls -A | grep -v -e '\''^\.\.$'\'' |xargs -i du -ks {} |sort -rn |head -16 | awk '\''{print $2}'\'' | xargs -i du -hs {}'
#alias ducks='ls -A | grep -v -e '\''^\.\.$'\'' |xargs -i du -ks {} |sort -rn |head -16 | awk '\''{ all=""; for (i=2; i<=NF; i++) all = $all,$i; print $all;}'\'' | xargs -i du -hs {}'
#alias ducks='find . -maxdepth 1 -mindepth 1 -print0  | xargs -0 -n1 du -ks | sort -rn | head -16 | cut -f2 | xargs -i du -hs {}'
alias ducks='find . -maxdepth 1 -mindepth 1 -print0  | xargs -0 -n1 du -ks | sort -rn | head -16 | cut -f2 | tr "\n" "\0" | xargs -0 du -hs'

# cool colors for manpages
# alias man="TERMINFO=~/.terminfo TERM=mostlike LESS=C PAGER=less man"

# for fun
alias iamcow='fortune | cowsay'
alias iamsurprise='fortune | cowsay -f $(random_cow)'

# The solution to put single-quotes within single-quotes: '\''
# Functions are probably a better idea of course. :)
alias cow_xmessage='xmessage -buttons MOO:0 -default MOO -center Hello, "$(whoami)". I$'\''\'\'''\''m a talking cow.$'\''\n'\''"$(fortune | cowsay)"'

# get your external IP
alias myip='echo My IP is && curl http://www.whatismyip.com/automation/n09230945.asp && echo'

# avoid segfault of zsnes
alias zsnes='zsnes -ad sdl'

alias qstatgrepuser='qstat | grep $USER'
alias qstatuser='qstat -u $USER'

#alias syncbindot='cd ~/bin_and_dotfiles_private/ && git pull && git push && git status; cd -; cd ~/bin_and_dotfiles_public/ && git pull && git push && git status; cd -'

alias modulegrep='module avail 2>&1 | grep '

alias cdtemp='cd $(mktemp -d )'

alias bashclean='env -i bash --noprofile --init-file /etc/profile'

# Fun with a personal quote file :)
alias addquote='editor $QUOTEFILE && strfile $QUOTEFILE'
# TODO: todo files or use todo.sh

alias fortune_custom='fortune -c 50% /usr/share/games/fortunes/ 50% $QUOTEFILE'
# hack para "fortunas" españolas :D (debería entregar un bug sobre el paquete) (con fortunes-fr, funciona simplemente con "fortune fr")
alias fortune_es='dpkg -L fortunes-es | grep dat | xargs -I{} basename {} .dat | xargs fortune'

alias secure_ssh='chmod 700 ~/.ssh/ && chmod 600 ~/.ssh/* && ls -ld ~/.ssh/ && ls -l ~/.ssh'

alias samba_start='sudo cp /etc/samba/smb.conf.on /etc/samba/smb.conf && sudo service smbd restart'
alias samba_stop='sudo cp /etc/samba/smb.conf.off /etc/samba/smb.conf && sudo service smbd stop'

alias list_network_apps='netstat -tuw | awk '\''{print $4}'\'' | grep -o -E ":[0-9]+" | xargs -n1 lsof -i'

alias move_pictures='mv -iv *.gif *.png *.bmp *.jpg *.jpeg *.GIF *.PNG *.BMP *.JPG *.JPEG'

# Usage: ssh_tunnel $PORT $HOST
alias ssh_tunnel='ssh -q -C2TnN -D'

# find all files with more than one hard link in the current directory and sort them by size
# listing them in the form:
# SIZE NLINKS INODE FILENAME
# TODO: Create fslint-gui like script/interface, to make processing easier
alias findHardLinkedFiles_SortBySize='find . -type f -links +1 -printf "%s=size nlinks=%n inode=%i file=%p \n" | sort -n'
alias findHardLinkedFiles_SortByInode='find . -type f -links +1 -printf "inode=%i %s=size nlinks=%n file=%p \n" | sort -n'
# TODO: Understand why '\'' works... Easier method?
alias countHardLinkedFiles='find . -type f -links +1 -printf "inode=%i file=%p \n" | awk '\''{print $1}'\'' | sort -u | wc -l'

# rsync aliases
alias rsync_to_Windows='rsync --archive --compress --no-perms --no-group --no-links --chmod=ugo=rwX'
alias rsync_to_GNULinux='rsync --archive --compress --hard-links'

alias commit-todo='cd $HOME/Desktop/TODO/ && git commit -am "todo"; cd -'

alias path='echo $PATH | tr ":" "\n"'
