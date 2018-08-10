#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re
import sys
import textwrap
import argparse
import tempfile
import subprocess

import email
import collections
import mailbox

import warnings

# TODO: figure out why the message count is different from thunderbird and webmail.
#   Is it due to this?:
#     Exception ignored in: <_io.FileIO name='INBOX' mode='rb+' closefd=True>
#     ResourceWarning: unclosed file <_io.BufferedRandom name='INBOX'>
#   It is also possible that the count is correct (grep -c "From " INBOX confirms this), but thunderbird does not save all mails in the mailbox file, but only the most recent 30 days... (due to settings)
#   This means reading the .msf file or using the email module might be the solution. Ideally a thunderbird built-in/addon tool of course...
# TODO: Count unread/read mails. X-Mozilla-Status, X-Mozilla-Status2 headers/flags?
# TODO: Process per directory, using thunderbirds layout?
# TODO: Use email module to directly access IMAP? cf: http://www.terminalinflection.com/python-script-email/
# Useful stuff:
#   https://github.com/KevinGoodsell/mork-converter
#   https://en.wikipedia.org/wiki/Mork_(file_format)
#   https://az4n6.blogspot.com/2014/04/whats-word-thunderbird-parser-that-is.html
#   https://stackoverflow.com/questions/953561/check-unread-count-of-gmail-messages-with-python
#   https://stackoverflow.com/questions/12042724/securely-storing-passwords-for-use-in-python-script
#   https://stackoverflow.com/questions/7014953/i-need-to-securely-store-a-username-and-password-in-python-what-are-my-options

def main():
  parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter,
                                    description=textwrap.dedent('''\
                                    Script to analyze a thunderbird mailbox file and sort by message count based on a specific field (from, to, etc).
                                    Useful for cleaning up a large inbox quickly. :)
                                    
                                    Based on: https://superuser.com/questions/479679/how-to-sort-thunderbird-by-message-count
                                    
                                    Example usage:
                                      thunderbird-sort-by-message-count.py --field="From" INBOX
                                    '''))
  parser.add_argument('mboxfile', nargs='+')
  parser.add_argument('-f', '--field')
  parser.add_argument('-v', '--verbose', action="count", dest="verbosity", default=0, help='verbosity level')
  args = parser.parse_args()
  
  warnings.simplefilter("error")
  
  if args.field is None:
    print('No field specified. Choose one from the following:')
    m = mailbox.mbox(args.mboxfile[0])
    em = m[0]
    print('--------------------------------------------------')
    for i in em.keys():
      print(i)
    print('--------------------------------------------------')
    sys.exit(-1)
  
  mailids = []
  N1 = 0
  N2 = 0
  N3 = 0
  
  N_read = 0
  N_unread = 0
  
  for mboxfile in args.mboxfile:
    N2 += len(mailbox.mbox(mboxfile))
    for em in mailbox.mbox(mboxfile):
      N1 += 1
      mailids.append(em[args.field])
      if 'X-Mozilla-Status' in em.keys():
        N_read += 1
      else:
        N_unread += 1
  
  count_dictionary = collections.Counter(mailids)
  count_dictionary_sorted = sorted(count_dictionary, key=lambda k: count_dictionary[k])
  
  for key in count_dictionary_sorted:
    N3 += count_dictionary[key]
    print('{}: {}'.format(count_dictionary[key], key))
  print('Total number of mails: {} {} {}'.format(N1, N2, N3))
  print('N_read = {}'.format(N_read))
  print('N_unread = {}'.format(N_unread))
  
  return 0

if __name__ == '__main__':
  main()
