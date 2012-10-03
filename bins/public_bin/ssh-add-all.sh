#!/bin/bash
cd ~/.ssh/
ls -1 *.pub | xargs -I{} basename {} .pub | tr "\n" " " | xargs ssh-add
cd -
