#!/bin/bash

# set -u

safe_link_dir()
{
  if [[ ! $1 ]];then exit 2; fi
  if [[ ! $2 ]];then exit 2; fi

  TARGET="$1"
  DEST="$2"
  FILE="$DEST/$(basename $TARGET)"

  if [ ! -e $TARGET ]
  then
    echo "ERROR: Target $TARGET not found."
    exit 1
  fi

  # check if target already exists and remove eventually
  if [ -L "$FILE" ] # FILE exists and is a symbolic link (same as -h)
  then
      echo "WARNING: Removing symbolic link $FILE"
      ls -l "$FILE"
      rm -v "$FILE"
  else
    if [ -e $FILE ]
    then
      echo "WARNING: $FILE already exists and is not a symbolic link."
      ls -l "$FILE"
      cp -iv "$FILE" "$FILE.$(date +%Y%m%d_%H%M%S)"
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

##### dir setup: change if you've placed the repository elsewhere. Variables can be passed by command line as follows:
# BIN_AND_DOTFILES_PRIVATE=foo BIN_AND_DOTFILES_PUBLIC=fuu  ./bins/public_bin/setup_dotfiles.sh

# BIN_AND_DOTFILES_PRIVATE=${BIN_AND_DOTFILES_PRIVATE:-$HOME/bin_and_dotfiles_private}
BIN_AND_DOTFILES_PRIVATE=${BIN_AND_DOTFILES_PRIVATE:-$HOME/Development/bin_and_dotfiles_private}

# BIN_AND_DOTFILES_PUBLIC=${BIN_AND_DOTFILES_PUBLIC:-$HOME/bin_and_dotfiles_public}
# BIN_AND_DOTFILES_PUBLIC=${BIN_AND_DOTFILES_PUBLIC:-$HOME/Development/bin_and_dotfiles_public}
BIN_AND_DOTFILES_PUBLIC=${BIN_AND_DOTFILES_PUBLIC:-$(readlink -f $(dirname $(readlink -f $0))/../..)}

echo "BIN_AND_DOTFILES_PRIVATE = ${BIN_AND_DOTFILES_PRIVATE}"
echo "BIN_AND_DOTFILES_PUBLIC = ${BIN_AND_DOTFILES_PUBLIC}"

# public configuration
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/bins/public_bin $HOME/bin
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.bash_aliases $HOME
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.bash_functions $HOME
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.bash_logout $HOME
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.bash_profile $HOME
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.bash_prompt $HOME
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.bashrc $HOME
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.bash_env_public $HOME
#safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.pystartup $HOME
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.vimrc $HOME

safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.inputrc $HOME

# bash->zsh transition work in progress
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.zshrc $HOME
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.zsh_prompt $HOME
safe_link_dir $BIN_AND_DOTFILES_PUBLIC/home/.zsh_profile $HOME

cd $BIN_AND_DOTFILES_PUBLIC
if [[ $GIT_USERNAME_JZ && $GIT_EMAIL_JZ ]]
then
  git config user.name $GIT_USERNAME_JZ
  git config user.email $GIT_EMAIL_JZ
else
  echo "WARNING: git identity not set. Skipping configuration."
fi
git config push.default matching
cd -

# private configuration
if [ -d $BIN_AND_DOTFILES_PRIVATE ]
then
  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/private_bin $HOME/bin
  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/community_bin $HOME/bin
  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/home/.bash_env_private $HOME
  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/home/.gitconfig $HOME
  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/home/todo.cfg $HOME
  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/home/.mrconfig $HOME
  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/home/.mrtrust $HOME

  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/dotfiles/.mrconfig.rsync ${RSYNCDIR}

  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/config $HOME/.ssh

  mkdir -p $HOME/.config/geany
  safe_link_dir $BIN_AND_DOTFILES_PRIVATE/home/.config/geany/keybindings.conf $HOME/.config/geany

  cd $BIN_AND_DOTFILES_PRIVATE
  if [[ $GIT_USERNAME_JZ && $GIT_EMAIL_JZ ]]
  then
    git config user.name $GIT_USERNAME_JZ
    git config user.email $GIT_EMAIL_JZ
  else
    echo "WARNING: git identity not set. Skipping configuration."
  fi
  git config push.default matching
  cd -

  chmod 700 $BIN_AND_DOTFILES_PRIVATE
  chmod 600 $HOME/.bash_env_private
else
  echo "WARNING: $BIN_AND_DOTFILES_PRIVATE not found"
fi
