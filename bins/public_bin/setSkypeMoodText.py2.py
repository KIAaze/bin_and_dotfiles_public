#!/usr/bin/env python2.6
# -*- coding: utf-8 -*-

# TODO: interface with chat windows as well. :) Skype bot?

from __future__ import division

import subprocess
import sqlite3
import os
import sys
import dbus
import re
import time
import optparse

# script to set/get Skype mood status
# cf also: https://pypi.python.org/pypi/Skype4Py/

# Initial result based on playing with main.db. Requires stopping Skype, calling functions and restarting Skype.
# DBfile should be in ~/.Skype/SKYPENAME/main.db
def MoodTextViaDBFile(DBfile, mood_text=None):
  try:
    if not os.path.isfile(DBfile):
      print '%s not found or is not a file' % DBfile
      return('')
    conn = sqlite3.connect(DBfile)
    c = conn.cursor()
    if mood_text is not None:
      conn.isolation_level = None # If you want autocommit mode, then set isolation_level to None.
      c.execute('UPDATE Accounts SET mood_text=?;',(mood_text,))
    c.execute('''select mood_text from Accounts;''')
    current_mood_text = c.fetchone()[0]
    c.close()
    conn.close()
    return(current_mood_text)
  except:
    print "Could not use DB file %s properly." % DBfile
    return("")

# much better way based on https://blog.arrington.me/2012/change-your-skype-mood-text-in-linux-with-python/
def MoodTextViaDbus(text=None):
  bus = dbus.SessionBus()
  try:
    proxy = bus.get_object('com.Skype.API', '/com/Skype')
    proxy.Invoke('NAME '+sys.argv[0])
    proxy.Invoke('PROTOCOL 2')
    if text is None:
      dbus_string = proxy.Invoke('GET PROFILE MOOD_TEXT')
    else:
      dbus_string = proxy.Invoke('SET PROFILE MOOD_TEXT %s' % text)
    mood_text = re.sub('^PROFILE MOOD_TEXT ','',str(dbus_string))
    return(mood_text)
  except:
    print "Could not contact Skype client"
    return("")

# function to use both (lambda form attempt failed)
def MoodText(DBfile=None, mood_text=None):
  if DBfile:
    return(MoodTextViaDBFile(DBfile, mood_text))
  else:
    return(MoodTextViaDbus(mood_text))

# for fun
def progress_bar(timestep=1):
  N = 10
  i = 0
  inc = 1
  while True:
    s = i*'='+'>'
    MoodTextViaDbus(s)
    i += inc
    if i>=N:
      i = N
      inc = -1
    elif i<=0:
      i = 0
      inc = 1
    time.sleep(timestep)

def progress_number(timestep=1, steps=123):
  for i in range(steps):
    MoodTextViaDbus('%6.2f%%'%(float(100*i)/(steps-1)))
    time.sleep(timestep)

def spinner(timestep=1):
  frames = ['/','-','\\','|']
  idx = 0
  while True:
    MoodTextViaDbus(frames[idx])
    idx = (idx+1)%len(frames)
    time.sleep(timestep)

# Scrolling text. :)
def scrolling_text(txt, timestep=1):
  while True:
    MoodTextViaDbus(txt)
    txt = txt[1:] + txt[0]
    time.sleep(timestep)

def read_file(filename, timestep=5):
  print(filename)
  with open(filename,'r') as f:
    for line in f:
      print(line) # TODO: option to enable/disable stdout/skype output
      MoodTextViaDbus(line)
      time.sleep(timestep)

def kirby(timestep=1):
  frames = [
    "<('o'<)",
    "^( '-' )^",
    "(>‘o’)>",
    "v( ‘.’ )v",
    "<(' .' )>",
    "<('.'<)",
    "^( '.' )^",
    "(>‘.’)>",
    "v( ‘.’ )v",
    "<(' .' )>"
    ]
  idx = 0
  while True:
    MoodTextViaDbus(frames[idx])
    idx = (idx+1)%len(frames)
    time.sleep(timestep)

# main function
def main():
  parser = optparse.OptionParser()
  parser.add_option("--DBfile")
  parser.add_option('--verbose', '-v', action='count', default=0)
  parser.add_option("-t", "--timestep", type=float, help='timestep in seconds for animations', default=1)
  parser.add_option("--steps", type=int, help='number of steps', default=100)
  # mutually exclusive group
  parser.add_option("-f", "--fortune", action="store_true", default=False)
  parser.add_option("-m", "--mood_text")
  parser.add_option("-p", "--progress_bar", action="store_true")
  parser.add_option("-s", "--spinner", action="store_true")
  parser.add_option("--progress_number", action="store_true")  
  parser.add_option("--scrolling_text")
  parser.add_option("--kirby", action="store_true")
  parser.add_option("--read-file")
  (options, args) = parser.parse_args()

  if options.verbose>1:
    print(options)

  #-------------------------
  # fun stuff
  if options.progress_bar:
    progress_bar(options.timestep)
    return

  if options.spinner:
    spinner(options.timestep)
    return

  if options.kirby:
    kirby(options.timestep)
    return

  if options.progress_number:
    progress_number(options.timestep, options.steps)
    return

  if options.scrolling_text:
    scrolling_text(options.scrolling_text, options.timestep)
    return

  if options.read_file:
    read_file(options.read_file, options.timestep)
    return

  #-------------------------
  # normal stuff
  mood_text = options.mood_text

  if options.fortune:
    p = subprocess.Popen(['fortune','-s'], stdout=subprocess.PIPE)
    mood_text = p.communicate()[0]
    mood_text += ' - random quote by the "fortune" program'

  if options.verbose>0:
    print('==>DBfile : %s'%(options.DBfile))
    print('==>argument mood text :\n---\n%s\n---' % mood_text)

  if mood_text is None:
    print('==>current mood text :\n---\n%s\n---' % MoodText(options.DBfile))
  else:
    print('==>old mood text :\n---\n%s\n---' % MoodText(options.DBfile))
    MoodText(options.DBfile, mood_text)
    print('==>new mood text :\n---\n%s\n---' % MoodText(options.DBfile))

if __name__ == '__main__':
  main()
