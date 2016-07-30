#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
Script to do various things with links.
At the moment mostly locating/removing/retargeting/converting (broken) symbolic links.
TODO: Add example for simple symlink to hardlink change. Clarify that hardlink is the default.
TODO: Make it work for relative symlinks.
TODO: Make converting symlinks to hard links easier.

CRITICAL BUG: If the link is a cross-device link, it will be removed, but fail to create a new hard link afterwards!
CRITICAL BUG: If the link is to a directory, it will be removed, but fail to create a new hard link afterwards!
example:
OSError: [Errno 18] Invalid cross-device link: '/usr/share/doc/texlive-doc/latex/tools/longtable.pdf' -> 'longtable.pdf'
TODO: check for cross-device links before any replacments. -> Or simply rename to tempfile, use try statement and rename back in case of failure.
'''

import argparse
import sys
import re
import os

def get_argument_parser():
  '''
  command-line option handling
  '''

  parser = argparse.ArgumentParser(description = 'Tool to work with links.')
  parser.add_argument('-v','--verbose', action="count", dest="verbosity", default=0, help='verbosity level')
  parser.add_argument("-n", "--no-act", action="store_true", dest="no_act", default=False, help="No Action: show what links would have been retargeted or removed.")
  parser.add_argument('--not-interactive', help='do not prompt before overwriting/removing', action="store_true", default=False)

  subparsers = parser.add_subparsers(help='Available subcommands')

  # parser for retargetLinks
  parser_retargetLinks = subparsers.add_parser('retarget', help='replace a symbolic link with a symbolic or hard link and a new target')

  parser_retargetLinks.add_argument('--use_sub', action="store_true", default=False, help='Use re.sub(pattern, repl) instead of str.replace(pattern, repl), i.e. basically use regular expressions instead of normal text.')
  parser_retargetLinks.add_argument('-s','--symbolic', action="store_true", default=False, help='create symbolic links instead of hard links')
  parser_retargetLinks.add_argument('-p','--pattern', required=True, help='pattern in link target to look for')
  parser_retargetLinks.add_argument('-r','--repl', required=True, help='string with which to replace the matched pattern')
  parser_retargetLinks.add_argument('link_name', nargs='+', help='The links you want to retarget.')
  
  parser_retargetLinks.set_defaults(func=retargetLinks)

  # parser for listBrokenSymlinks
  parser_listBrokenSymlinks = subparsers.add_parser('list', help='list broken symbolic links and eventually remove them.')
  parser_listBrokenSymlinks.add_argument("-r", "--remove", action="store_true", default=False, help="Remove found broken links.")
  parser_listBrokenSymlinks.add_argument('DIR', nargs='+', help='The directories you want to search.')
  
  parser_listBrokenSymlinks.set_defaults(func=listBrokenSymlinks)
  
  return parser

def listBrokenSymlinks(arguments):
  '''
  Prints out broken symlinks and their targets.
  Also allows removing those broken symlinks interactively or automatically.

  Returns a tuple (broken_symlinks, dirs_with_broken_symlinks) where:
  -broken_symlinks is a list of (fullpath, target) tuples where:
    -fullpath is the path of a broken symlink
    -target is the corresponding link target
  -dirs_with_broken_symlinks is a set of directories containing broken symlinks
  
  # TODO: skip/select files based on pattern?
  # TODO: only look for dir symlinks?
  '''

  broken_symlinks = []
  dirs_with_broken_symlinks = set()

  for current_directory in arguments.DIR:
    
    if not os.path.isdir(current_directory):
      print('ERROR:' + current_directory + 'is not a directory. Skipping.', file=sys.stderr)
      continue
    
    for root, dirs, filenames in os.walk(current_directory, followlinks=True):
      for f in filenames:
        fullpath = os.path.join(root, f)
        if os.path.islink(fullpath):
          target = os.readlink(fullpath)
          if not os.path.exists(target) and not os.path.exists(os.path.join(root, target)):
            broken_symlinks.append((fullpath, target))
            dirs_with_broken_symlinks.add(root)
            print('broken symlink: {} -> {}'.format(fullpath, target))
            if arguments.remove:
              if arguments.not_interactive:
                ans = 'y'
              else:
                ans = input('Remove broken symlink: {} -> {}? (y/n): '.format(fullpath, target)).strip()
              if ans == 'y':
                if not arguments.no_act:
                  os.remove(fullpath)
                else:
                  print('Removing ' + fullpath)
          else:
            if arguments.verbosity > 1:
              print('working symlink: {} -> {}'.format(fullpath, target))
  
  if arguments.verbosity > 0:
    print('The following {} directories contain broken symlinks:'.format(len(dirs_with_broken_symlinks)))
    for i in dirs_with_broken_symlinks:
      print(i)
  
  return( (broken_symlinks, dirs_with_broken_symlinks) )

def retargetLinks(arguments):
  '''
  Change the target of symbolic links or replace them with hard links to a new target.
  The target is renamed based on the current target using python's str.replace() or re.sub() for pattern substitution.
  '''
  
  for link_name in arguments.link_name:
    print('--> Processing ' + link_name)
    if not os.path.lexists(link_name):
      print(link_name+' does not exist.', file=sys.stderr)
      continue
    if not os.path.islink(link_name):
      print(link_name+' is not a symbolic link.', file=sys.stderr)
      continue

    old_target = os.readlink(link_name)
    if arguments.use_sub:
      new_target = re.sub(arguments.pattern, arguments.repl, old_target)
    else:
      new_target = old_target.replace(arguments.pattern, arguments.repl)
    
    if arguments.verbosity > 0:
      print('link_name = ' + link_name)
      print('old_target = ' + old_target)
      print('new_target = ' + new_target)
    if os.path.exists(new_target):
      
      # skip if target is a directory and not using symlinks
      if os.path.isdir(new_target) and not arguments.symbolic:
        print(new_target + ' is a directory. Hard linking not supported. Skipping ' + link_name, file=sys.stderr)
        continue
      
      if arguments.not_interactive:
        ans = 'y'
      else:
        ans = input('Relink {} from {} to {}? (y/n): '.format(link_name,old_target,new_target)).strip()
      if ans == 'y':
        if not arguments.no_act:
          os.remove(link_name)
          if arguments.symbolic:
            os.symlink(new_target, link_name)
          else:
            os.link(new_target, link_name)
      else:
        print('Skipping ' + link_name)
    else:
      print(new_target + ' not found. Skipping ' + link_name, file=sys.stderr)
  return
  
def main():
  parser = get_argument_parser()
  arguments = parser.parse_args()

  if arguments.verbosity > 0:
    print('---------')
    print(arguments)
    print('---------')
  
  if not len(sys.argv) > 1:
    parser.print_help()
  else:
    arguments.func(arguments)

  return(0)

if __name__ == "__main__":
  main()
