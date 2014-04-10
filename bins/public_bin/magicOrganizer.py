#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
 Reorganizes files according to unique files.

 Example:
 You have:
  src/b1/b1.a
  src/b1/b1.b
  src/b2/b2.a
  src/b2/b2.b
  src/b3/b3.a
  src/b3/b3.b
  src/b4/b4.a
  src/b4/b4.b

 Assuming b1.a=b3.a and b2.a=b4.a (more specifically same sha1sum), it allows you to reorganize the files as follows:

  dst/sha1sum_of_b1.a/b1/b1.a
  dst/sha1sum_of_b1.a/b1/b1.b
  dst/sha1sum_of_b1.a/b3/b3.a
  dst/sha1sum_of_b1.a/b3/b3.b

  dst/sha1sum_of_b2.a/b2/b2.a
  dst/sha1sum_of_b2.a/b2/b2.b
  dst/sha1sum_of_b2.a/b4/b4.a
  dst/sha1sum_of_b2.a/b4/b4.b

 by running:
  magicOrganizer.py organize -s ./src -d ./dst -p "*.a"

 TODO: Check out the following modules: fileinput, filecmp, difflib
 TODO: Document pattern usage.
 TODO: Make sure there are no problems when src is in dst or dst in src...
 TODO: "directory pruner/stripper: remove useless dirs from a long directory tree. ex: /a/b/c/d/e/* -> /a_b_c_d_e/* or similar."
 TODO: pass multiple source directories or specific dirs conatining matching files
 TODO: Add option to only move if there are multiple "dir matches".
"""

import os
import sys
import argparse
import hashlib
import subprocess
import fnmatch
import tempfile
import shutil

def fromdos(filename):
  """ convert to unix format """
  try:
    retcode = subprocess.call(["fromdos", filename])
    if retcode < 0:
      print("Child was terminated by signal", -retcode, file=sys.stderr)
    #else:
      #print("Child returned", retcode, file=sys.stderr)
  except OSError as e:
    print("Execution failed:", e, file=sys.stderr)

def getSha1sumOfUnixVersion(filename):
  """ get the sha1sum corresponding to the UNIX version of the file (i.e. like after running fromdos/dos2unix) """
  with open(filename, 'rb') as f:
    sha1sum = hashlib.sha1(f.read().replace(b'\r\n',b'\n')).hexdigest()      
    return(sha1sum)

def getSha1sum(filename):
  with open(filename, 'rb') as f:
    sha1sum = hashlib.sha1(f.read()).hexdigest()
    return(sha1sum)

def moveContents(srcdir,dstdir):
  """ move contents of srcdir into dstdir """
  contents = os.listdir(srcdir)
  for i in contents:
    src_item = os.path.join(srcdir,i)
    dst_item = os.path.join(dstdir,i)
    #print((src_item, dstdir))
    try:
      if os.path.isfile(dstdir):
        print('ERROR:',dstdir,'is a file!!! Aborting to avoid overwriting files while moving contents.', file=sys.stderr)
        sys.exit(-1)
      shutil.move(src_item, dstdir)
    except OSError as e:
      print("Execution failed:", e, file=sys.stderr)

def organize(arguments):
  """
  Automagically organize data folders...
  
  First we analyze the directory structure for any potential problems.
  Then, starting from the deepest directory, we move all directories containing files matching the specified pattern into the corresponding sha1sum folder with the same relative path.
  """
  
  for do_process in [False, True]:

    fileAndSha1sum_list = []

    if arguments.verbose:
      if not do_process:
        print('=== ANALYSIS ===')
      else:
        print('=== PROCESSING ===')

    for root, dirname_list, filename_list in os.walk(arguments.srcdir, topdown=False):

      if arguments.verbose > 1:
        print('--> root = ',root)
      if arguments.verbose > 2:
        print('files',len(filename_list))
        print('dirs:',len(dirname_list))

      local_sha1sum_set = set()
      local_fileAndSha1sum_list = []

      for filename in filename_list:

        # check filename against patterns
        match = False

        for pattern_to_match in arguments.pattern:
          if fnmatch.fnmatch(filename, pattern_to_match):
            match = True

        for pattern_to_exclude in arguments.exclude_pattern:
          if fnmatch.fnmatch(filename, pattern_to_exclude):
            match = False
        
        # if match, get the sha1sum and add it to the sets/lists
        if match:

          # build the pathname
          fullpath = os.path.join(root, filename)

          # check it exists, just in case
          if not os.path.exists(fullpath):
            print('ERROR: ' + fullpath + 'does not exist anymore. Probably already moved due to other matching file with same sha1sum. Aborting.', file=sys.stderr)
            sys.exit(-1)

          sha1sum = getSha1sumOfUnixVersion(fullpath)
          
          if arguments.verbose:
            print((sha1sum, fullpath))
          
          # we don't need all those lists. Leftovers from debugging.
          fileAndSha1sum_list.append( (sha1sum, fullpath) )
          local_fileAndSha1sum_list.append( (sha1sum, fullpath) )
          local_sha1sum_set.add(sha1sum)
      
      if len(local_sha1sum_set) > 1:
        # no single sha1sum
        print('ERROR:',root,'contains more than one matching file, but not with the same sha1sum.')
        sys.exit(-1)

      elif do_process and len(local_sha1sum_set) == 1:
        # move directory

        if arguments.verbose > 1:
          print('Number of matching files with same sha1sum: {}'.format(len(local_fileAndSha1sum_list)))

        (sha1sum, fullpath) = local_fileAndSha1sum_list[0]

        src = os.path.dirname(fullpath) # could just be set to root
        dst = os.path.join(arguments.dstdir, sha1sum, os.path.relpath(src, start=arguments.srcdir))
        
        if os.path.samefile(src,arguments.srcdir):
          print('WARNING:',fullpath,'is in the root of the source directory',arguments.srcdir,'which cannot be moved. Skipping.', file=sys.stderr)
          continue

        if arguments.verbose:
          print('Moving',src,'to',dst)
        
        # if the destination exists and is not empty
        if os.path.exists(dst) and os.listdir(dst):
          print('WARNING:',dst,'exists and is not empty! Just moving contents.', file=sys.stderr)
          if not arguments.no_act:
            moveContents(src,dst)
        else:
          if not arguments.no_act:
            if not os.path.isdir(src):
              print('ERROR:',src,'is not a directory!!! Aborting to avoid overwriting files while renaming.', file=sys.stderr)
              sys.exit(-1)
            os.renames(src,dst)

  return

def rename(arguments):
  """ automagically rename data folders... """
  
  if len(set(arguments.pattern))!=len(arguments.pattern):
    print('ERROR: Some of the specified patterns are identical.', file=sys.stderr)
    sys.exit(-1)
  
  for src in arguments.folders:
    
    if not os.path.exists(src):
      print('WARNING:',src,'does not exist. Skipping.', file=sys.stderr)
      continue

    #print('renaming')
    match_dict = {}
    for p in arguments.pattern:
      #match_list.append(set())
      match_dict[p] = set()
    #print(match_dict)


    if arguments.verbose > 1:
      print('==>Processing', src)
    for root, dirnames, filenames in os.walk(src):
      #print('dirnames',dirnames)
      #print('filenames',filenames)
      if arguments.verbose > 3: print('dirnames+filenames :', dirnames+filenames)
      for p in arguments.pattern:
        #print('Matching',p)
        #match_dict[p].add()
        #print(fnmatch.filter(dirnames, p))
        #print(fnmatch.filter(filenames, p))
        if arguments.verbose > 3: print('Matches for ',p,' :',fnmatch.filter(dirnames+filenames, p))
        for match in fnmatch.filter(dirnames+filenames, p):
          match_dict[p].add(match)
          if arguments.verbose > 2:
            print('adding',match,'for',p)
        if arguments.verbose > 3: print('--> match_dict:', match_dict)
      #local_sha1sum_set = set()
      #for filename in fnmatch.filter(filenames, arguments.pattern):
        #if not arguments.exclude_pattern or not ( filename in fnmatch.filter(filenames, arguments.exclude_pattern) ):
    #print(match_dict)
    
    if arguments.verbose > 2: 
      print('==> final match_dict:', match_dict)
      print('=========================')
    matches_ok = True

    path_elements = []
    #for k in match_dict.keys():
    for k in arguments.pattern:
      if len(match_dict[k]) == 1:
        path_elements.append(match_dict[k].pop())
      else:
        matches_ok = False
    
    if matches_ok:
      if arguments.verbose > 1:
        print(path_elements)

      #dst = os.path.join(*path_elements)
      
      dst = ''
      for i in range(len(path_elements)):
        if i==0:
          dst += path_elements[i]
        else:
          dst += '.' + path_elements[i]
        
      dst = os.path.join(os.path.dirname(os.path.normpath(src)), dst)

      if arguments.verbose > 1:
        print('dst :',dst)
      
      if os.path.exists(dst):
        if os.path.samefile(src, dst):
          print('WARNING: Source == Destination ==', os.path.normpath(dst), 'Skipping.', file=sys.stderr)
          continue
        else:
          if arguments.add_suffix_if_dest_exists:
            suffix = 0
            dst_orig = dst
            while os.path.exists(dst):
              dst = dst_orig + '_' + str(suffix)
              suffix += 1
      
      if not os.path.exists(dst):
        if arguments.verbose:
          print(src,'->',dst)
        if not arguments.no_act:
          os.rename(src, dst)
      else:
        print('WARNING: Destination exists:', dst, 'Skipping.', file=sys.stderr)
        continue
        
    else:
      print('WARNING: Some patterns did not produce exactly one match. Skipping', src, file=sys.stderr)
      #print('match_dict :',match_dict, file=sys.stderr)
      continue
    
  return

def removeDuplicatesMain(arguments):

  # sanity check
  if os.path.samefile(arguments.origdir,arguments.dupdir):
    print('ERROR:',arguments.origdir,'and',arguments.dupdir,'refer to the same path!!!', file=sys.stderr)    
    sys.exit(-1)
  
  if arguments.remove_only_if_all_duplicates:
    
    #backup original arguments
    no_act_orig = arguments.no_act
    #verbose_orig = arguments.verbose
    
    arguments.no_act = True
    notRemoved = removeDuplicates(arguments)
    
    if notRemoved == 0:
      arguments.no_act = no_act_orig
      arguments.verbose = 0 # second run is silent for convenience
      notRemoved = removeDuplicates(arguments)
    else:
      print('WARNING: No files were actually removed because not all would be removed.', file=sys.stderr)
    
  else:
    notRemoved = removeDuplicates(arguments)
  
  return(notRemoved)

def removeDuplicates(arguments):

  # sanity check
  if os.path.samefile(arguments.origdir,arguments.dupdir):
    print('ERROR:',arguments.origdir,'and',arguments.dupdir,'refer to the same path!!!', file=sys.stderr)    
    sys.exit(-1)

  notRemoved = 0
  for f in os.listdir(arguments.dupdir):
    if arguments.verbose>2:
      print('=== Processing',f,'===')
    fullpath_orig = os.path.join(arguments.origdir,f)
    fullpath_dup = os.path.join(arguments.dupdir,f)
    if os.path.isfile(fullpath_dup):
      if os.path.isfile(fullpath_orig):
        
        # sanity check
        if os.path.samefile(fullpath_dup,fullpath_orig):
          print('ERROR:',fullpath_dup,'and',fullpath_orig,'refer to the same path!!!', file=sys.stderr)
          sys.exit(-1)
        
        sha1sum_dup = getSha1sum(fullpath_dup)
        sha1sum_orig = getSha1sum(fullpath_orig)
        if arguments.verbose>2:
          print(sha1sum_dup,fullpath_dup)
          print(sha1sum_orig,fullpath_orig)
        if sha1sum_dup == sha1sum_orig:
          if arguments.verbose:
            print('Removing',fullpath_dup,'which is a duplicate of',fullpath_orig)
          if not arguments.no_act:
            os.remove(fullpath_dup)
        else:
          notRemoved += 1
          if arguments.verbose>1:
            print('NOT removing',fullpath_dup,'which is NOT a duplicate of',fullpath_orig)
      else:
        notRemoved += 1
        if arguments.verbose>1:
          print('NOT removing',fullpath_dup,': There is no such file in the original directory.')
    else:
      notRemoved += 1
      if arguments.verbose>1:
        print('NOT removing',fullpath_dup,': It is not a file.')
  return(notRemoved)

def get_argument_parser():
  """ command-line option handling """
  parser = argparse.ArgumentParser(description = 'Tools to organize files and folders.', fromfile_prefix_chars='@')

  parser.add_argument('-v','--verbose', action="count", default=0, help='verbosity level')
  parser.add_argument("-n", "--no-act", action="store_true", default=False, help="Do not actually rename/move files. Just simulate.")

  subparsers = parser.add_subparsers(title='subcommands', description='valid subcommands', help='available operations', dest='operation')
  
  parser_organize = subparsers.add_parser('organize', help='Sort folders containing specific files into folders named after the sha1sums of those files.')
  parser_organize.add_argument('-s', '--srcdir', help='source directory to scan for .EXT files', required=True)
  parser_organize.add_argument('-d', '--dstdir', help='destination directory into which to sort folders', required=True)
  parser_organize.add_argument('-p', '--pattern', help='patterns the files should match', required=True, action='append')
  parser_organize.add_argument('-x', '--exclude-pattern', help='patterns the files should not match', action='append', default=[])
  parser_organize.set_defaults(func=organize)

  parser_rename = subparsers.add_parser('rename', help='rename folders based on contents matching patterns')
  parser_rename.add_argument('folders', action="store", nargs='+', help='folders to rename')
  parser_rename.add_argument('-p','--pattern', action="append", help='pattern to match', required=True)
  parser_rename.add_argument("--add-suffix-if-dest-exists", action="store_true", default=False, help="Add a suffix if a destination with the same name already exists.")
  parser_rename.set_defaults(func=rename)

  parser_removeDuplicates = subparsers.add_parser('removeDuplicates', help='remove duplicates from another directory')
  parser_removeDuplicates.add_argument('-o','--origdir', help='original directory to which files will be compared and from which nothing is deleted', required=True)
  parser_removeDuplicates.add_argument('-d','--dupdir', help='directory with potential duplicate files', required=True)
  parser_removeDuplicates.add_argument("--remove-only-if-all-duplicates", action="store_true", default=False, help="Remove duplicates only if all files are duplicates, i.e. if the directory would be emptied on a normal run.")
  parser_removeDuplicates.set_defaults(func=removeDuplicatesMain)

  return parser

def main(args=None):
  parser = get_argument_parser()
  arguments = parser.parse_args() if args is None else parser.parse_args(args) # This is just to enable calling the main function with arguments from another script for example.

  if arguments.verbose:
    print('---------')
    print(arguments)
    print('---------')
  
  if not len(sys.argv) > 1 or arguments.operation is None:
    parser.print_help()
  else:
    return(arguments.func(arguments))
  
  return(0)

if __name__ == "__main__":
  sys.exit(main())
