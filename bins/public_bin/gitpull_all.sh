#!/bin/bash

sync_git()
{
  echo "=== $1 ==="
  cd $1 && git pull && git status; cd -;
}
sync_git ~/bin_and_dotfiles_public
sync_git ~/Development/script_inception_public
