#!/usr/bin/env python3

# Configure name+mail in git more easily.
# Example 1: Select a name+mail pair from one of the previous commits:
#   git-config-submitter.py
# Example 2: Pass a name+mail pair using the format used in git log output, i.e. "name <mail>":
#   git-config-submitter.py first last <user@host>
#
# TODO: global config? But then I wouldn't need this script. ;)
# TODO: GUI for name selection? list of previously used name+mail pairs?

import re
import sys
import subprocess

def main():
  an = None
  ae = None
  if len(sys.argv) == 1:
    author_name_list = subprocess.check_output(['git', 'log', '--pretty=format:%an'], universal_newlines=True).split('\n')
    author_mail_list = subprocess.check_output(['git', 'log', '--pretty=format:%ae'], universal_newlines=True).split('\n')
    print(author_name_list)
    print(author_mail_list)

    for an,ae in zip(author_name_list, author_mail_list):
      ans = input('Use {} <{}>? (y/n): '.format(an, ae))
      if ans == 'y':
        break
  else:
    s = sys.argv[1]
    p = re.compile('(.*) <(.*)>')
    m = p.match(s)
    if m:
      an, ae = m.groups()
      print(an)
      print(ae)
    else:
      raise Exception('Invalid name/mail string. It should be of the form: "name <mail>"')
    
  if an is not None and ae is not None:
    print('Setting default commiter to:\n  {} <{}>'.format(an, ae))
    cmd = ['git', 'config', 'user.name', '{}'.format(an)]
    subprocess.check_call(cmd)
    cmd = ['git', 'config', 'user.email', '{}'.format(ae)]
    subprocess.check_call(cmd)

    print('You may fix the identity used for the last commit with:')
    print('  git commit --amend --reset-author')
  return

if __name__ == '__main__':
  main()
