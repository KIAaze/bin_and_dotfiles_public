#!/usr/bin/env python2
# -*- coding: utf-8 -*-

# TODO: interface with chat windows as well. :) Skype bot?

from __future__ import division, print_function

import subprocess
import sqlite3
import os
import sys
import dbus
import re
import time
#import optparse
import argparse

# script to set/get Skype mood status
# cf also: https://pypi.python.org/pypi/Skype4Py/

# Initial result based on playing with main.db. Requires stopping Skype, calling functions and restarting Skype.
# DBfile should be in ~/.Skype/SKYPENAME/main.db
def MoodTextViaDBFile(DBfile, mood_text=None):
  try:
    if not os.path.isfile(DBfile):
      print('{} not found or is not a file'.format(DBfile))
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
    print("Could not use DB file {} properly.".format(DBfile))
    return("")

# much better way based on https://blog.arrington.me/2012/change-your-skype-mood-text-in-linux-with-python/
def MoodTextViaDbus(text=None, waitForSkype=0):
  
  bus = dbus.SessionBus()
  
  if waitForSkype > 0:
    time_start = time.time()
    while 'com.Skype.API' not in bus.list_names():
      # timeout after 
      if time.time() - time_start > waitForSkype:
        print('ERROR: Timeout while getting dbus object.', file=sys.stderr)
        return("")
      pass
  
  try:
    print('--> dbus part start')
    print('getting object')
    proxy = bus.get_object('com.Skype.API', '/com/Skype')
    print('invoke 1')
    proxy.Invoke('NAME '+sys.argv[0])
    print('invoke 2')
    proxy.Invoke('PROTOCOL 2')
    if text is None:
      print('invoke get')
      error_str = 'ERROR 68'
      dbus_string = proxy.Invoke('GET PROFILE MOOD_TEXT')
      if dbus_string == error_str and waitForSkype > 0:
        while dbus_string == error_str:
          #print('getting object')
          proxy = bus.get_object('com.Skype.API', '/com/Skype')
          #print('invoke 1')
          proxy.Invoke('NAME '+sys.argv[0])
          #print('invoke 2')
          proxy.Invoke('PROTOCOL 2')
          dbus_string = proxy.Invoke('GET PROFILE MOOD_TEXT')
          if time.time() - time_start > waitForSkype:
            print('ERROR: Timeout while getting mood text.', file=sys.stderr)
            return("")
    else:
      print('invoke set')
      dbus_string = proxy.Invoke('SET PROFILE MOOD_TEXT %s' % text)
    mood_text = re.sub('^PROFILE MOOD_TEXT ','',str(dbus_string))
    print('--> dbus part done')
    return(mood_text)
  except:
    print("Could not contact Skype client")
    return("")

# function to use both (lambda form attempt failed)
def MoodText(DBfile=None, mood_text=None, waitForSkype=0):
  if DBfile:
    return(MoodTextViaDBFile(DBfile, mood_text))
  else:
    return(MoodTextViaDbus(mood_text, waitForSkype))

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
  parser = argparse.ArgumentParser()
  parser.add_argument("--DBfile")
  parser.add_argument('--verbose', '-v', action='count', default=0)
  parser.add_argument("-t", "--timestep", type=float, help='timestep in seconds for animations', default=1)
  parser.add_argument("--steps", type=int, help='number of steps', default=100)
  # mutually exclusive group
  parser.add_argument("-f", "--fortune", action="store_true", default=False)
  parser.add_argument("-m", "--mood_text", const="", nargs="?")
  parser.add_argument("-p", "--progress_bar", action="store_true")
  parser.add_argument("-s", "--spinner", action="store_true")
  parser.add_argument("--progress_number", action="store_true")  
  parser.add_argument("--scrolling_text")
  parser.add_argument("--kirby", action="store_true")
  parser.add_argument("--read-file")
  parser.add_argument("-w", "--waitForSkype", type=int, help="Wait at least TIME seconds for skype to be available via dbus.", const=1*60, default=0, metavar="TIME", nargs="?")
  options = parser.parse_args()

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
    print('==>current mood text :\n---\n%s\n---' % MoodText(options.DBfile, mood_text=None, waitForSkype=options.waitForSkype))
  else:
    print('==>old mood text :\n---\n%s\n---' % MoodText(options.DBfile, mood_text=None, waitForSkype=options.waitForSkype))
    MoodText(options.DBfile, mood_text, waitForSkype=options.waitForSkype)
    print('==>new mood text :\n---\n%s\n---' % MoodText(options.DBfile, mood_text=None, waitForSkype=options.waitForSkype))

if __name__ == '__main__':
  main()
