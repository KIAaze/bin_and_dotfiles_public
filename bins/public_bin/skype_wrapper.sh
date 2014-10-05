#!/bin/zsh

if [ -f ~/.bash_env ]; then
  source ~/.bash_env
fi

if [ -f ~/.bash_local ]; then
  source ~/.bash_local
fi

mkdir -p "$HOME/log"
LOGFILE="$HOME/log/skype_wrapper.log"

echo "===" 1>> $LOGFILE 2>&1
date 1>> $LOGFILE 2>&1
echo "PATH = $PATH" 1>> $LOGFILE 2>&1

skype &
echo "SKYPE_MOOD_TEXT = ${SKYPE_MOOD_TEXT}" 1>> $LOGFILE 2>&1
setSkypeMoodText.py2.py --waitForSkype --mood_text=${SKYPE_MOOD_TEXT} 1>> $LOGFILE 2>&1
