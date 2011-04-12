#!/bin/bash
#back up Documents folder on external HD using rsync :)
rsync -avZ $HOME/Documents/ /media/CLASSIC\ SL/Documents/  && finished.sh
