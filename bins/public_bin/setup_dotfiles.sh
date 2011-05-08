#!/bin/bash

set -u

safe_link_dir()
{
	TARGET="$1"
	DEST="$2"
	FILE="$DEST/$(basename $TARGET)"
	if [ -e $FILE ]
	then
		echo "$FILE already exists."
		ls -l "$FILE"
	else
		if [ -h "$FILE" ]
		then
			rm -iv "$FILE"
		fi
		echo "Linking $TARGET"
		ln -s "$TARGET" "$FILE"
	fi
}

if [ -L $HOME/bin ]
then
	rm -iv $HOME/bin
fi

mkdir -p $HOME/bin
safe_link_dir $HOME/bin_and_dotfiles_private/private_bin $HOME/bin
safe_link_dir $HOME/bin_and_dotfiles_private/community_bin $HOME/bin
safe_link_dir $HOME/bin_and_dotfiles_public/bins/public_bin $HOME/bin

safe_link_dir $HOME/bin_and_dotfiles_public/home/.bash_aliases $HOME
safe_link_dir $HOME/bin_and_dotfiles_private/home/.bash_env $HOME
safe_link_dir $HOME/bin_and_dotfiles_public/home/.bash_functions $HOME
safe_link_dir $HOME/bin_and_dotfiles_public/home/.bash_logout $HOME
safe_link_dir $HOME/bin_and_dotfiles_public/home/.bash_profile $HOME
safe_link_dir $HOME/bin_and_dotfiles_public/home/.bash_prompt $HOME
safe_link_dir $HOME/bin_and_dotfiles_public/home/.bashrc $HOME
safe_link_dir $HOME/bin_and_dotfiles_public/home/.pystartup $HOME
safe_link_dir $HOME/bin_and_dotfiles_private/home/.gitconfig $HOME
safe_link_dir $HOME/bin_and_dotfiles_private/home/todo.cfg $HOME

safe_link_dir $HOME/bin_and_dotfiles_private/config $HOME/.ssh

safe_link_dir $HOME/bin_and_dotfiles_private/home/.config/geany/keybindings.conf $HOME/.config/geany

chmod 700 $HOME/bin_and_dotfiles_private
chmod 700 $HOME/.bash_env

cd $HOME/bin_and_dotfiles_private
git config user.name $GIT_USERNAME_JZ
git config user.email $GIT_EMAIL_JZ
git config push.default matching
cd -

cd $HOME/bin_and_dotfiles_public
git config user.name $GIT_USERNAME_JZ
git config user.email $GIT_EMAIL_JZ
git config push.default matching
cd -
