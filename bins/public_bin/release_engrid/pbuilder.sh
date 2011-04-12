#!/bin/bash
#This is not a script yet. Just a list of the commands to run. ;)
sudo pbuilder create
sudo pbuilder update --components "main restricted universe multiverse" --override-config
sudo pbuilder build ../webcontentcontrol_1.1.7-0ubuntu1.dsc

pdebuild

