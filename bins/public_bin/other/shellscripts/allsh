#!/bin/sh
#
# $Id: allsh,v 1.3 2005/08/31 04:11:30 jmates Exp $
#
# The author disclaims all copyrights and releases this script into the
# public domain.
#
# Script to work with shell signal trapping to run shell commands in
# all shells. For example using zsh, set the following in ~/.zshrc:
#
# TRAPUSR2() {
#   [ -f ~/.sh-sourceall ] && . ~/.sh-sourceall
# }
#
# Warning! This script has various potential security problems,
# especially where multiple users are involved with a shared account
# (root), or where write access to the ~/.sh-sourceall file is possible
# by untrusted users, e.g. via untrusted code injection into the file
# in question, especially if ~/.sh-sourceall is on an insecure network
# file system.

# routine to signal a process matching an expression with a
# specified signal.
#
# another option might be to have shells write their pids to somewhere
# like ~/.zsh/shellpids/$$, then just run through that file list, though
# cleanup of the files could be problematic
signalit () {
  PATTERN=$1
  SIGNAL=$2

  # TODO this ps not portable to things like Solaris...
  ps xwwo pid,command | while read pid command; do
    if echo $command | egrep -- "$PATTERN" >/dev/null; then
      kill -$SIGNAL $pid
    fi
  done
}

if [ -z "$1" ]; then
  echo "usage: `basename $0` [shell statements|-]"
  exit 1
fi

# TODO test new expression first in a subshell to ensure it will work
# before running it everywhere?

# KLUGE just clobber a known file, which will cause problems if multiple
# 'allsh' are run or if multiple users are involve somehow
if [ "$1" = '-' ]; then
  cat > ~/.sh-sourceall
else
  echo "$@" > ~/.sh-sourceall
fi

# KLUGE this signal is dependent on how the shell shows itself via the
# ps command run... need to add more shells, maybe figure out something
# more portable?
signalit '[-/]zsh$' USR2
#signalit '[-/]bash$' USR2
