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

syncbindot()
{
  echo "=== Synching private repo ==="
  cd ~/bin_and_dotfiles_private/ && git pull && git push && git status; cd -;
  echo "=== Synching public repo ==="
  cd ~/bin_and_dotfiles_public/ && git pull && git push && git status; cd -;
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
