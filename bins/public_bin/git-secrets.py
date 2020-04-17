#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from __future__ import division

import os
import re
import sys
import argparse
import tempfile
import subprocess
import textwrap

def getWords():
  wordlist = []
  cmd = ['git', 'secrets', '--list']
  p = subprocess.run(cmd, check=True, stdout=subprocess.PIPE)
  secretfile = p.stdout.split()[-1]
  with open(secretfile) as secrets:
    for i in secrets:
      word = i.strip()
      wordlist.append(word)
  return wordlist

def listWords(args):
  wordlist = getWords()
  for i in wordlist:
    print(i)

def scan(args):

  # get txt to grep
  if args.infile:
    txt = args.infile.read()
  else:
    if args.history:
      cmd = ['git', 'secrets', '--scan-history']
    else:
      cmd = ['git', 'secrets', '--scan']
    p = subprocess.run(cmd, check=False, stderr=subprocess.PIPE)
    txt = p.stderr

  # show full matches
  print('===> matches:')
  matches = set()
  wordlist = getWords()
  for word in wordlist:
    cmd = ['grep', '--line-number', '--color=auto', word]
    p = subprocess.run(cmd, input=txt, stdout=subprocess.PIPE)
    if p.returncode==0:
      matches.add(word)
      print('=== {} ==='.format(word))
      p = subprocess.run(cmd, input=txt)

  # show matching words only
  print('===> matching words:')
  for i in matches:
    print(i)
  return

def main():
  parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter,

  description=textwrap.dedent('''\
        A script to help with the use of git-secrets.

        Example uses:
        -------------

        Print out the list of prohibited patterns:
          git-secrets.py listWords

        Print out the matches by word, and then list the matching words at the end:
          Scan the whole history:
            git-secrets.py scan --history
          Scan the latest version of files in the repository:
            git-secrets.py scan
          Scan a specific file:
            git-secrets.py scan FILE
          ''')
  )
  parser.add_argument('-v', '--verbose', action="count", dest="verbosity", default=0, help='verbosity level')
  subparsers = parser.add_subparsers()

  parser_listWords = subparsers.add_parser('listWords')
  parser_listWords.set_defaults(func=listWords)

  parser_scan = subparsers.add_parser('scan')
  parser_scan.add_argument('--history', action='store_true')
  parser_scan.add_argument('infile', nargs='?', type=argparse.FileType('rb'))
  parser_scan.set_defaults(func=scan)
  
  args = parser.parse_args()

  if 'func' in args:
    args.func(args)
  else:
    parser.print_help()

if __name__ == '__main__':
  main()
