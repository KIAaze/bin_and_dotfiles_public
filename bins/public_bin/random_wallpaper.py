#! /usr/bin/env python
#sets a random picture from ~/Pictures/wallpapers/ as wallpaper.

import random
import os
import glob

pics=glob.glob(os.path.expanduser('~/Pictures/wallpapers/*'))
picture=random.choice(pics)
picture=picture.replace("\'","\\'")
picture=picture.replace(" ","\\ ")

#cmd='gconftool-2 --set /desktop/gnome/background/picture_filename '+picture+' -t string'
#os.system(cmd)

#save the filename of the used picture so it can be used by realtime_wallpaper.py :D
f=open(os.path.expanduser('~/.random_wallpaper'),'w')
f.write(picture)
f.close()

#call realtime_wallpaper
os.system(os.path.expanduser('~/bin/realtime_wallpaper.py'))
