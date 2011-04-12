#! /usr/bin/env python
#changes the wallpaper brightness according to the current daytime. :)

import datetime
import os

now=datetime.datetime.now()

H=int(now.strftime("%H"))
M=int(now.strftime("%M"))
S=int(now.strftime("%S"))

print str(H)+":"+str(M)+":"+str(S)

t = S + M * 60 + H * 60 * 60
print t

day_start= 0 + 0 * 60 + 0 * 60 * 60
day_mid= 0 + 0 * 60 + 12 * 60 * 60
day_end= 0 + 0 * 60 + 24 * 60 * 60
print day_start
print day_mid
print day_end

if t < day_mid:
	brightness=100 * t / day_mid
else:
	brightness=100 * ( day_end - t ) / day_mid

print brightness

#get the filename of the used picture ( this file is created by random_wallpaper.py)
f=open(os.path.expanduser('~/.random_wallpaper'),'r')
picture=f.readline()
f.close()

print picture
#picture=picture.replace("\'","\\'")
#print picture
#picture=picture.replace(" ","\\ ")
#print picture

realtime_wallpaper=os.path.expanduser('~/.realtime_wallpaper.jpg')
print realtime_wallpaper

realtime_wallpaper_buffer=os.path.expanduser('~/.realtime_wallpaper_buffer.jpg')
print realtime_wallpaper_buffer

cmd='convert '+picture+' -modulate '+str(brightness)+' '+realtime_wallpaper
print cmd
os.system(cmd)

#cmd='gconftool-2 --set /desktop/gnome/background/picture_filename '+realtime_wallpaper+' -t string'
#print cmd
#os.system(cmd)
