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

# other
alias datefull='date +%Y%m%d_%H%M%S'
alias pmake='make -j$(num_threads)'
# alias h='history'
alias rlogin='slogin -X'
alias astyle_all='astyle *.h *.cpp */*.h */*.cpp'
alias wc_all='wc -l *.h *.cpp */*.h */*.cpp | sort'

# to be able to use aliases under sudo
alias sudo='A=`alias` sudo  '

# rebuild aliases
alias rebuild_all='qmake && make distclean && qmake && make -j$(num_threads) debug release && checkcmd'
alias rebuild_debug='qmake && make distclean && qmake && make -j$(num_threads) debug && checkcmd'
alias rebuild_release='qmake && make distclean && qmake && make -j$(num_threads) release && checkcmd'

#alias git_log_month='echo $1'git log --after="$1 1 2009" --before="Jul 1 2009"
alias profile='valgrind --tool=callgrind --dump-instr=yes --simulate-cache=yes --collect-jumps=yes'
alias git_checkall='git pull && git push && git status'
alias bzr_checkall='bzr pull && bzr push && bzr status'

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

# get your external IP
alias myip='echo My IP is && curl http://www.whatismyip.com/automation/n09230945.asp && echo'

# avoid segfault of zsnes
alias zsnes='zsnes -ad sdl'

alias qstatuser='qstat | grep $USER'
#alias syncbindot='cd ~/bin_and_dotfiles_private/ && git pull && git push && git status; cd -; cd ~/bin_and_dotfiles_public/ && git pull && git push && git status; cd -'

alias modulegrep='module avail 2>&1 | grep '

alias cdtemp='cd $(mktemp -d )'

alias bashclean='env -i bash --noprofile --init-file /etc/profile'

# Fun with a personal quote file :)
alias addquote='editor $QUOTEFILE && strfile $QUOTEFILE'
alias fortune_custom='fortune -c 50% /usr/share/games/fortunes/ 50% $QUOTEFILE'
# hack para fortunas españolas :D (debería entregar un bug sobre el paquete) (con fortunes-fr, funciona simplement con "fortune fr")
alias fortune_es='dpkg -L fortunes-es | grep dat | xargs -I{} basename {} .dat | xargs fortune'

alias secure_ssh='chmod 700 ~/.ssh/ && chmod 600 ~/.ssh/* && ls -ld ~/.ssh/ && ls -l ~/.ssh'
