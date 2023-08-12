#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# <pep8-80 compliant>

# .. todo:: global config? But then I wouldn't need this script. ;)
# .. todo:: GUI for name selection? list of previously used name+mail pairs? -> could use pick module...

import re
import sys
import argparse
import textwrap
import subprocess

def parseCommiter(commiter):
  p = re.compile('(.*) <(.*)>')
  m = p.match(commiter)
  if m:
    name, email = m.groups()
  else:
    raise Exception(textwrap.dedent('''
      Invalid name/mail string.
      It should be of the form: "name <email>"'''))
  return (name, email)

def setCommiter(name, email):
  # apply name+email
  if name is not None and email is not None:
    print('Setting default commiter to:\n  {} <{}>'.format(name, email))
    cmd = ['git', 'config', 'user.name', '{}'.format(name)]
    subprocess.check_call(cmd)
    cmd = ['git', 'config', 'user.email', '{}'.format(email)]
    subprocess.check_call(cmd)

    print('You may fix the identity used for the last commit with:')
    print('  git commit --amend --reset-author')
    print('Or for the last N commits with:')
    print('  git rebase HEAD~N -x "git commit --amend --reset-author --no-edit"')
    print('And if you want it to be interactive:')
    print('  git rebase -i HEAD~N -x "git commit --amend --reset-author --no-edit"')
    print('And edit commit messages:')
    print('  git rebase -i HEAD~N -x "git commit --amend --reset-author"')
  else:
    print('Nothing changed.')

  return

def getCommiter():
  cmd_name = ['git', 'config', 'user.name']
  cmd_mail = ['git', 'config', 'user.email']
  
  an = None
  ae = None
  
  try:
    an = subprocess.run(cmd_name, check=True, stdout=subprocess.PIPE).stdout.decode().strip()
    ae = subprocess.run(cmd_mail, check=True, stdout=subprocess.PIPE).stdout.decode().strip()
  except:
    print('Failed to find current committer.')
  
  if an is not None and ae is not None:
    print('Current committer:')
    print('"{} <{}>"'.format(an, ae))
  #if sys.version_info >= (3,5):
    #an = subprocess.run(cmd, check=True, stdout=subprocess.PIPE).stdout
  #subprocess.check_output(cmd)
  #a.decode().strip()
  return

def main():
  
    #############################
    # argparse

    description_string = '''
    Configure name+mail in git more easily.

    Example 1:
    Select a name+mail pair from one of the previous commits:
      git-config-submitter.py

    Example 2:
    Pass a name+mail pair using the format used in git log output,
    i.e. "name <mail>":
      git-config-submitter.py "first last <user@host>"
    '''

    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=textwrap.dedent(description_string))

    parser.add_argument('-i', '--interactive', action='store_true', help='Interactively ask for commiter.')
    parser.add_argument('submitter', nargs='?')
    args = parser.parse_args()
    #############################

    # default name+email values
    #an = None
    #ae = None

    if args.submitter:  # if submitter specified, parse it
      (an, ae) = parseCommiter(args.submitter)
      setCommiter(an, ae)
    else:  # if no submitter specified, get it from log
      #author_name_list = subprocess.check_output(['git', 'log', '--pretty=format:%an'], universal_newlines=True)
      #author_name_list = author_name_list.split('\n')
      
      #author_mail_list = subprocess.check_output(['git', 'log', '--pretty=format:%ae'], universal_newlines=True)
      #author_mail_list = author_mail_list.split('\n')
      
      author_name_mail_list = subprocess.check_output(['git', 'log', '--pretty=format:%an <%ae>'], universal_newlines=True)
      author_name_mail_list = author_name_mail_list.split('\n')
      
      author_name_mail_list_unique = []
      author_name_mail_set = set()
      
      for i in author_name_mail_list:
        if i not in author_name_mail_set:
          author_name_mail_list_unique.append(i)
          author_name_mail_set.add(i)
      
      getCommiter()
      print('Current list of commiters:')
      for i in author_name_mail_list_unique:
        print('"{}"'.format(i))
      
      if args.interactive:
        
        for i in author_name_mail_list_unique:
          print(i)
          (an, ae) = parseCommiter(i)
          ans = input('Use {} <{}>? (y/n): '.format(an, ae))
          if ans == 'y':
            setCommiter(an, ae)
            break
          
        #print(author_name_list[0:3])
        #print(author_mail_list[0:3])
        #print(author_mail_list[0:3])

        #for an_tmp, ae_tmp in zip(author_name_list, author_mail_list):
            #ans = input('Use {} <{}>? (y/n): '.format(an_tmp, ae_tmp))
            #if ans == 'y':
                #an = an_tmp
                #ae = ae_tmp
                #break

    return

if __name__ == '__main__':
    main()
