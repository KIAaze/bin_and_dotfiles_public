#!/bin/bash
# cf https://wiki.archlinux.org/index.php/KDE_Wallet#Using_the_KDE_Wallet_to_store_ssh_keys
cd ~/.ssh/
# ls -1 *.pub | xargs -I{} basename {} .pub | tr "\n" " " | xargs -I{} ssh-add {} </dev/null
ssh-add $(ls -1 *.pub | xargs -I{} basename {} .pub | tr "\n" " ") </dev/null
cd -
