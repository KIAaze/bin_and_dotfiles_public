# ~/.bash_functions

mailme()
{
	echo "$@" | mail -s "$1" $WORKMAIL
}

random_cow()
{
  files=(/usr/share/cowsay/cows/*)
  printf "%s\n" "${files[RANDOM % ${#files}]}"
}

num_threads()
{
    cores=`grep cores /proc/cpuinfo | wc -l`
#     echo cores=$cores
    if [ $cores -eq 0 ]; then cores=1; fi
    procs=`grep processor /proc/cpuinfo | wc -l`
#     echo procs=$procs
    thrds=`expr $cores \* $procs`
    thrds=$cores
    echo $thrds;
}

# back up .bash* files
backup_bashfiles()
{
  ARCHIVE="$HOME/bash_dotfiles_$(date +%Y%m%d_%H%M%S).tar.gz";
  cd ~
  if [ $1 -eq 0 ]
  then
    tar -czvf $ARCHIVE .bashrc .bash_functions .bash_aliases .bash_prompt
  else
    tar -czvf $ARCHIVE .bashrc .bash_functions .bash_aliases .bash_prompt .bash_profile
  fi
  echo "All backed up in $ARCHIVE";
}

whichreally()
{
  readlink -f $(which "$1");
}

lessexe()
{
  less $(readlink -f $(which "$1"));
}

moreexe()
{
  more $(readlink -f $(which "$1"));
}

catexe()
{
  cat $(readlink -f $(which "$1"));
}

vimexe()
{
  vim $(readlink -f $(which "$1"));
}

catbin()
{
  cat $HOME/bin/$1;
}

lessbin()
{
  less $HOME/bin/$1;
}

vimbin()
{
  vim $HOME/bin/$1;
}

syncgitrepo()
{
  echo "=== Synching $1 ==="
  if [ -d "$1" ]; then
    cd "$1" && git pull && git push && git status; cd -;
  else
    echo "$1 does not exist or is not a directory."
  fi
}

syncbindot()
{
  syncgitrepo ~/bin_and_dotfiles_private/
  syncgitrepo ~/bin_and_dotfiles_public/
}

rtm() {
  echo '' | mail -s "$*" $EMAIL_RTM
}

rtm_file() {
  cat "$1" | while read line; do
    rtm "$line"
  done
}

# improve this, might require python
qstatuserfull()
{
  #qstatuser | awk '{print $1}' | xargs qstat -f | grep -A 1 Job_Name
  #qstatuser | awk '{print $1}' | xargs qstat -f | grep -A 5 JOBDIR
  qstatuser | awk '{print $1}' | xargs qstat -f | grep -A 2 JOBDIR
}

##########################################
# ssh-agent stuff
##########################################
# ideas:
# -get SSH_AUTH_SOCK from PID
# -check for multiple ssh-agent agents running
# -if AGENTFILE info does not correspond to ssh-agent process, kill it and start new one.
# TODO: See if we can use Gnome or KDE keyring depending on environment. (ssh-add -D does not delete identities from the Gnome keyring)
# TODO: Create script/function to auto-add all identities in ~/.ssh? Better to just have one key per system or one key per app?

ssh_agent_restart()
{
  # depends on hostname to support systems with multiple login nodes and shared home directory
  AGENTFILE="$HOME/agent.$(hostname).sh"
  # Note: added --user in case other users are running their own agents
  AGENTPID=`/bin/ps -f --user $USER | grep ssh-agent | grep -v grep  | awk '{print $2}' | xargs`
  if [ -n "$AGENTPID" ]; then
    # better than killall to avoid error messages coming from trying to kill processes by other users
    kill $AGENTPID
  fi
  ssh-agent | grep -v echo >$AGENTFILE
  if [ -e "$AGENTFILE" ]; then
    source "$AGENTFILE"
  fi
}

ssh_agent_start()
{
  AGENTFILE="$HOME/agent.$(hostname).sh"
  if [ -e "$AGENTFILE" ]; then
    source "$AGENTFILE"
    if ! ( [ -n "$SSH_AUTH_SOCK" ] && [ -e "$SSH_AUTH_SOCK" ] ); then
      ssh_agent_restart
    fi
  else
    ssh_agent_restart
  fi
}

ssh_agent_check()
{
  # DIAGNOSTICS
  #      Exit status is 0 on success (found stored identities), 1 if the specified command fails (found no stored identities), and 2 if ssh-add is unable to contact the authentication agent.
  ssh-add -l
  if [ $? -ne 2 ]
  then
    echo "ssh-agent running correctly!"
  else
    echo "ERROR: Failed to initialize working ssh-agent!"
  fi
}
