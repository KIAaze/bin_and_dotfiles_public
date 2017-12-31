#!/bin/bash
# cf: http://board.zsnes.com/phpBB3/viewtopic.php?f=18&t=12339
# It finally worked after also removing an old ~/.zsnes config.
# alternative: use retroarch
for i in /usr/lib/x86_64-linux-gnu/ao/plugins-4/*
do
  echo $i
  sudo ln -s $i /usr/lib/ao/plugins-4/$(basename ${i%.so}-32.so)
done
