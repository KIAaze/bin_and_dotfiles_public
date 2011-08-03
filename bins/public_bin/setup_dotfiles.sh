#!/bin/bash

set -u

safe_link_dir()
{
  TARGET="$1"
  DEST="$2"
  FILE="$DEST/$(basename $TARGET)"

  # check if target already exists and remove eventually
  if [ -e $FILE ]
  then
    if [ -L "$FILE" ] # FILE exists and is a symbolic link (same as -h)
    then
      echo "WARNING: Removing symbolic link $FILE"
      ls -l "$FILE"
      rm -v "$FILE"
    else
      echo "WARNING: $FILE already exists and is not a symbolic link."
      ls -l "$FILE"
      rm -iv "$FILE"
    fi
  fi

  # link if the file does not exist
  if [ ! -e $FILE ]
  then
    echo "Linking $TARGET"
    ln -s "$TARGET" "$FILE"
  fi
}

# prepare ~/bin directory
if [ -L $HOME/bin ] # FILE exists and is a symbolic link (same as -h)
then
  rm -iv $HOME/bin
fi
mkdir -p $HOME/bin

# dir setup: change if you've placed the repository elsewhere
BIN_AND_DOTFILES_PRIVATE=$HOME/bin_and_dotfiles_private
BIN_AND_DOTFILES_PUBLIC=$HOME/bin_and_dotfiles_public

# public configuration
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/bins/public_bin $HOME/bin
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.bash_aliases $HOME
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.bash_functions $HOME
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.bash_logout $HOME
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.bash_profile $HOME
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.bash_prompt $HOME
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.bashrc $HOME
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.pystartup $HOME

cd $BIN_AND_DOTFILES_PUBLIC
git config user.name $GIT_USERNAME_JZ
git config user.email $GIT_EMAIL_JZ
git config push.default matching
cd -

# private configuration
if [ -d $BIN_AND_DOTFILES_PRIVATE ]
then
  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/private_bin $HOME/bin
  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/community_bin $HOME/bin
  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/home/.bash_env $HOME
  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/home/.gitconfig $HOME
  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/home/todo.cfg $HOME

  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/config $HOME/.ssh

  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/home/.config/geany/keybindings.conf $HOME/.config/geany

  cd $BIN_AND_DOTFILES_PRIVATE
  git config user.name $GIT_USERNAME_JZ
  git config user.email $GIT_EMAIL_JZ
  git config push.default matching
  cd -

  chmod 700 $BIN_AND_DOTFILES_PRIVATE
  chmod 700 $HOME/.bash_env
else
  echo "WARNING: $BIN_AND_DOTFILES_PRIVATE not found"
fi
