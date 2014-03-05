#!/usr/bin/env python3

import subprocess
import argparse
import sqlite3
import os
import sys

# DBfile should be in ~/.Skype/SKYPENAME/main.db

def getMoodText(DBfile):
  conn = sqlite3.connect(DBfile)
  c = conn.cursor()
  c.execute('''select mood_text from Accounts;''')
  current_mood_text = c.fetchone()[0]
  c.close()
  conn.close()
  return(current_mood_text)
  
def setMoodText(DBfile, mood_text):
  conn = sqlite3.connect(DBfile)
  conn.isolation_level = None # If you want autocommit mode, then set isolation_level to None.
  c = conn.cursor()
  c.execute('UPDATE Accounts SET mood_text=?;',(mood_text,))
  c.close()
  conn.close()
  return

parser = argparse.ArgumentParser()
parser.add_argument("DBfile")
parser.add_argument('--verbose', '-v', action='count', default=0)
group = parser.add_mutually_exclusive_group()
group.add_argument("-f", "--fortune", action="store_true", default=False)
group.add_argument("-m", "--mood_text")
args = parser.parse_args()

if args.verbose>1:
  print(args)

mood_text = args.mood_text

if args.fortune:
  mood_text = subprocess.check_output(["fortune", "-s"], universal_newlines=True)
  mood_text += ' - random quote by the "fortune" program'

if args.verbose>0:
  print('==>DBfile : {}'.format(args.DBfile))
  print('==>argument mood text :\n---\n{}\n---'.format(mood_text))

if not os.path.isfile(args.DBfile):
  sys.exit('{} not found or is not a file'.format(args.DBfile))

if mood_text is None:
  print('==>current mood text :\n---\n{}\n---'.format(getMoodText(args.DBfile)))
else:
  print('==>old mood text :\n---\n{}\n---'.format(getMoodText(args.DBfile)))
  setMoodText(args.DBfile, mood_text)
  print('==>new mood text :\n---\n{}\n---'.format(getMoodText(args.DBfile)))
