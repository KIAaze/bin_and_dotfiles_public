#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import argparse
import hashlib
import subprocess
import fnmatch
import tempfile
import shutil

####################################
# Reorganizes files according to unique files.
#
# Example:
# You have:
#  src/b1/b1.a
#  src/b1/b1.b
#  src/b2/b2.a
#  src/b2/b2.b
#  src/b3/b3.a
#  src/b3/b3.b
#  src/b4/b4.a
#  src/b4/b4.b
#
# Assuming b1.a=b3.a and b2.a=b4.a (more specifically same sha1sum), it allows you to reorganize the files as follows:
#
#  dst/sha1sum_of_b1.a/b1/b1.a
#  dst/sha1sum_of_b1.a/b1/b1.b
#  dst/sha1sum_of_b1.a/b3/b3.a
#  dst/sha1sum_of_b1.a/b3/b3.b
#
#  dst/sha1sum_of_b2.a/b2/b2.a
#  dst/sha1sum_of_b2.a/b2/b2.b
#  dst/sha1sum_of_b2.a/b4/b4.a
#  dst/sha1sum_of_b2.a/b4/b4.b
#
# by running:
#  magicOrganizer.py -s ./src -d ./dst -p "*.a"
####################################

# convert to unix format
def fromdos(filename):
  try:
    retcode = subprocess.call(["fromdos", filename])
    if retcode < 0:
      print("Child was terminated by signal", -retcode, file=sys.stderr)
    #else:
      #print("Child returned", retcode, file=sys.stderr)
  except OSError as e:
    print("Execution failed:", e, file=sys.stderr)

# get the sha1sum corresponding to the UNIX version of the file (i.e. like after running fromdos/dos2unix)
def getSha1sumOfUnixVersion(filename):
  with open(filename, 'rb') as f:
    sha1sum = hashlib.sha1(f.read().replace(b'\r\n',b'\n')).hexdigest()      
    return(sha1sum)

def getSha1sum(filename):
  with open(filename, 'rb') as f:
    sha1sum = hashlib.sha1(f.read()).hexdigest()
    return(sha1sum)

# move contents of srcdir into dstdir
def moveContents(srcdir,dstdir):
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

# automagically organize data folders...
def organize(arguments):
  
  fileAndSha1sum_list = []
  
  # TODO: It might be possible to combine the two os.walks into one...
  
  if arguments.verbose:
    print('=== ANALYSIS ===')
  # first we analyze the directory structure for any potential problems
  for root, dirnames, filenames in os.walk(arguments.srcdir, topdown=False):
    local_sha1sum_set = set()
    local_fileAndSha1sum_list = []
    for filename in fnmatch.filter(filenames, arguments.pattern):
      if not arguments.exclude_pattern or not ( filename in fnmatch.filter(filenames, arguments.exclude_pattern) ):
      
        # build the pathname
        fullpath = os.path.join(root, filename)
        
        # get their sha1sums
        sha1sum = getSha1sumOfUnixVersion(fullpath)
        
        if arguments.verbose:
          print((sha1sum, fullpath))
        
        fileAndSha1sum_list.append( (sha1sum, fullpath) )
        local_fileAndSha1sum_list.append( (sha1sum, fullpath) )
        local_sha1sum_set.add(sha1sum)
    
    if(len(local_sha1sum_set)>1):
      print('ERROR:',root,'contains more than one matching file, but not with the same sha1sum.')
      sys.exit(-1)
  
  fileAndSha1sum_list = []
  
  if arguments.verbose:
    print('=== PROCESSING ===')
  # starting from the deepest directory move all directories containing files matching the specified pattern into the corresponding sha1sum folder with the same relative path
  for root, dirnames, filenames in os.walk(arguments.srcdir, topdown=False):
    for filename in fnmatch.filter(filenames, arguments.pattern):
      if not arguments.exclude_pattern or not ( filename in fnmatch.filter(filenames, arguments.exclude_pattern) ):
      
        # build the pathname
        fullpath = os.path.join(root, filename)

        if not os.path.exists(fullpath):
          # TODO: Directory moving should be handled in a nicer way. You can only move a dir once after all. i.e. Should check all files in dir and then process it, also avoidig need for pre-processing. -> process dirnames instead of filenames.
          print('WARNING:',fullpath,'does not exist anymore. Probably already moved do to other matching file with same sha1sum. Skipping.', file=sys.stderr)
          continue
        
        # get their sha1sums
        sha1sum = getSha1sumOfUnixVersion(fullpath)
        
        if arguments.verbose:
          print((sha1sum, fullpath))
        
        fileAndSha1sum_list.append( (sha1sum, fullpath) )
        
        src = os.path.dirname(fullpath)
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

  ## get all unique sha1sums
  #sha1sum_set = {sha1sum for (sha1sum, fullpath) in fileAndSha1sum_list}
  
  ## create folder for each sha1sum
  #for sha1sum in sha1sum_set:
    #if arguments.verbose:
      #print(sha1sum)
    #os.makedirs(os.path.join(arguments.dstdir,sha1sum), exist_ok=True)

  #for root, dirs, files in os.walk(sys.argv[1]):
    #for name in files:
      #print(os.path.join(root, name))
    #for name in dirs:
      #print(os.path.join(root, name))
  
  #os.makedirs(sys.argv[1], exist_ok=True)

  #os.renames(sys.argv[1],os.path.join(sys.argv[2],sys.argv[1]))

# automagically rename data folders...
def rename(arguments):
  
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
  # command-line option handling
  parser = argparse.ArgumentParser(description = 'Tools to organize files and folders.', fromfile_prefix_chars='@')

  parser.add_argument('-v','--verbose', action="count", default=0, help='verbosity level')
  parser.add_argument("-n", "--no-act", action="store_true", default=False, help="Do not actually rename/move files. Just simulate.")

  subparsers = parser.add_subparsers(title='subcommands', description='valid subcommands', help='available operations', dest='operation')
  
  parser_organize = subparsers.add_parser('organize', help='Sort folders containing specific files into folders named after the sha1sums of those files.')
  parser_organize.add_argument('-s','--srcdir', help='source directory to scan for .EXT files', required=True)
  parser_organize.add_argument('-d','--dstdir', help='destination directory into which to sort folders', required=True)
  parser_organize.add_argument('-p','--pattern', help='patterns the files should match', required=True)
  parser_organize.add_argument('--exclude-pattern', help='patterns the files should not match')
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
