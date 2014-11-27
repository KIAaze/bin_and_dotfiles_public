#!/bin/bash
# ~/.bash_functions

mailme()
{
  echo "$@" | mail -s "$1" $WORKMAIL
}

# gpg help:

#--armor
#
#-a     Create ASCII armored output.  The default is to create the binary OpenPGP format.

#--sign
#
#-s     Make a signature. This command may be combined with --encrypt (for a signed and encrypted message), --symmetric (for a signed and symmetri‐
#      cally encrypted message), or --encrypt and --symmetric together (for a signed message  that  may  be  decrypted  via  a  secret  key  or  a
#      passphrase).  The key to be used for signing is chosen by default or can be set with the --local-user and --default-key options.

#--symmetric
#
#-c     Encrypt  with  a  symmetric cipher using a passphrase. The default symmetric cipher used is CAST5, but may be chosen with the --cipher-algo
#      option. This option may be combined with --sign (for a signed and symmetrically encrypted message), --encrypt (for a message  that  may  be
#      decrypted  via a secret key or a passphrase), or --sign and --encrypt together (for a signed message that may be decrypted via a secret key
#      or a passphrase).

#--encrypt
#
#-e     Encrypt  data.  This  option  may  be  combined  with  --sign  (for a signed and encrypted message), --symmetric (for a message that may be
#      decrypted via a secret key or a passphrase), or --sign and --symmetric together (for a signed message that may be decrypted  via  a  secret
#      key or a passphrase).

#--recipient name
#
#-r     Encrypt  for  user id name. If this option or --hidden-recipient is not specified, GnuPG asks for the user-id unless --default-recipient is
#      given.

#--default-key name
#      Use  name  as the default key to sign with. If this option is not used, the default key is the first key found in the secret keyring.  Note
#      that -u or --local-user overrides this option.

#--local-user name
#
#-u     Use name as the key to sign with. Note that this option overrides --default-key.

# TODO: command to easily mail (in encrypted+signed form, sent from root for example, with user as recipient) input from stdin, or directly files as attachment
# TODO: find out how to attach file(s) to a mail by command line.

gpgmailme_signed()
{
  # usage: gpgmailme SUBJECT CONTENT
  echo "$@" | gpg --sign --armor | mail -s "$1" $WORKMAIL
}

gpgmailme_encrypted()
{
  # usage:
  # echo CONTENT | gpgmailme_encrypted SUBJECT
  # cat FILE | gpgmailme_encrypted SUBJECT
  SRCMAIL=$WORKMAIL
  DSTMAIL=$WORKMAIL
  SUBJECT=$1
  gpg --local-user "$SRCMAIL" --recipient "$DSTMAIL" --encrypt --sign --armor | mail -s "$SUBJECT" "$DSTMAIL"
}

random_cow()
{
  files=(/usr/share/cowsay/cows/*)
  printf "%s\n" "${files[RANDOM % ${#files[*]}]}"
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

# We use /usr/bin/which instead of just which, so it also works properly in zsh which has a built-in which (problem appears with aliased commands).
# TODO: Make it work with aliased commands as well.
whichreally()
{
  readlink -f $(/usr/bin/which "$1");
}

lessexe()
{
  less $(readlink -f $(/usr/bin/which "$1"));
}

moreexe()
{
  more $(readlink -f $(/usr/bin/which "$1"));
}

catexe()
{
  cat $(readlink -f $(/usr/bin/which "$1"));
}

vimexe()
{
  vim $(readlink -f $(/usr/bin/which "$1"));
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

move_to_writeonly()
{
  for f in "$@"
  do
    mv -iv "$f" "/opt/writeonly/$f.$RANDOM"
  done
}

# convert video to ogg audio file
# Tip: Use the following options of youtube-dl instead:
# -x, --extract-audio        convert video files to audio-only files (requires
#                                          ffmpeg or avconv and ffprobe or avprobe)
# --audio-format FORMAT      "best", "aac", "vorbis", "mp3", "m4a", "opus", or
#                                          "wav"; best by default
mp4_to_ogg()
{
  for i in "$@"
  do
    echo "=== Converting $i ==="
    ffmpeg2theora --novideo -o "${i%.mp4}.ogg" "$i"
  done
}

# extract and delete a zip
zip2dir()
{
  for i in "$@"
  do
    echo "=== Processing $i ==="
    atool -x "$i" && rm -iv "$i"
  done
}

### torque utilities
# improve this, might require python -> done in qstat.py
qstatuserfull()
{
  # note: qstat -u $USER breaks this because it passes on invalid JOB IDs...
  #qstatuser | awk '{print $1}' | xargs qstat -f | grep -A 1 Job_Name
  #qstatuser | awk '{print $1}' | xargs qstat -f | grep -A 5 JOBDIR
  qstat | grep $USER | awk '{print $1}' | xargs qstat -f | grep -A 2 JOBDIR
}

qstat-summary()
{
        Ntotal=$(qstat -u $USER | grep -c $USER)
        Nrunning=$(qstat -u $USER | grep $USER | grep -c " R ")
        Nqueued=$(qstat -u $USER | grep $USER | grep -c " Q ")
        echo "job status: running = ${Nrunning} queued = ${Nqueued} total = ${Ntotal}"
}
