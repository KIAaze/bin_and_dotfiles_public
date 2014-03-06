#!/usr/bin/env python3

import subprocess
import argparse
import sqlite3
import os
import sys
import dbus
import re
import time

# script to set/get Skype mood status
# cf also: https://pypi.python.org/pypi/Skype4Py/

# Initial result based on playing with main.db. Requires stopping Skype, calling functions and restarting Skype.
# DBfile should be in ~/.Skype/SKYPENAME/main.db
def MoodTextViaDBFile(DBfile, mood_text=None):
  try:
    if not os.path.isfile(DBfile):
      print('{} not found or is not a file'.format(DBfile), file=sys.stderr)
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
    print("Could not use DB file {} properly.".format(DBfile), file=sys.stderr)
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
      dbus_string = proxy.Invoke('SET PROFILE MOOD_TEXT {}'.format(text))
    mood_text = re.sub('^PROFILE MOOD_TEXT ','',str(dbus_string))
    return(mood_text)
  except:
    print("Could not contact Skype client", file=sys.stderr)
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
    MoodTextViaDbus('{:6.2f}%'.format(100*i/(steps-1)))
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
  group = parser.add_mutually_exclusive_group()
  group.add_argument("-f", "--fortune", action="store_true", default=False)
  group.add_argument("-m", "--mood_text")
  group.add_argument("-p", "--progress_bar", action="store_true")
  group.add_argument("-s", "--spinner", action="store_true")
  group.add_argument("--progress_number", action="store_true")  
  group.add_argument("--scrolling_text")
  group.add_argument("--kirby", action="store_true")
  args = parser.parse_args()

  if args.verbose>1:
    print(args)

  #-------------------------
  # fun stuff
  if args.progress_bar:
    progress_bar(args.timestep)
    return

  if args.spinner:
    spinner(args.timestep)
    return

  if args.kirby:
    kirby(args.timestep)
    return

  if args.progress_number:
    progress_number(args.timestep, args.steps)
    return

  if args.scrolling_text:
    scrolling_text(args.scrolling_text, args.timestep)
    return

  #-------------------------
  # normal stuff
  mood_text = args.mood_text

  if args.fortune:
    mood_text = subprocess.check_output(["fortune", "-s"], universal_newlines=True)
    mood_text += ' - random quote by the "fortune" program'

  if args.verbose>0:
    print('==>DBfile : {}'.format(args.DBfile))
    print('==>argument mood text :\n---\n{}\n---'.format(mood_text))

  if mood_text is None:
    print('==>current mood text :\n---\n{}\n---'.format(MoodText(args.DBfile)))
  else:
    print('==>old mood text :\n---\n{}\n---'.format(MoodText(args.DBfile)))
    MoodText(args.DBfile, mood_text)
    print('==>new mood text :\n---\n{}\n---'.format(MoodText(args.DBfile)))

if __name__ == '__main__':
  main()
