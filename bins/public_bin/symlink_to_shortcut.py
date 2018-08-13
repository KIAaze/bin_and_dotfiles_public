#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Converts symlinks to text files containing the file location (with an optional left stripping of a base path)

# TODO: Convert to real Windows shortcuts. And create a shortcut->symlink function. (Check for existing code online.)
# TODO: hardlink to symlink converter...
# TODO: fslint-gui like tool to take care of things like that? or fslint-gui extension/improvement?
# TODO: Warn if -i and destination dir are specified together (try to make incompatible through argparse)

# what we want to be able to do:
# cp src dst
# mv src dst
# mv src src

#if dst=src: remove src

# example to convert all symlinks in current dir to "text shortcuts":
# symlink_to_shortcut.py -v -d . -i

# TODO: merge with link_tool.py by adding it as a possible action? (or rename scripts to make finding them easier)

import sys
import os
import argparse
import tempfile

# TODO: Check out distutils, create_shortcut(target, description, filename[, arguments[, workdir[, iconpath[, iconindex]]]]) for creating correct windows shortcuts.
def create_shortcut_text_file(TARGET, LINK_NAME, use_tempfile=False):
  ''' Create a text file containing the text "Link to src" named dst. '''
  if use_tempfile:
    f, fname = tempfile.mkstemp(dir=os.path.dirname(LINK_NAME))
    os.close(f)
  else:
    if os.path.lexists(LINK_NAME):
      raise Exception('Destination file exists: {}'.format(LINK_NAME))
    fname = LINK_NAME
  
  with open(fname, 'w') as f:
    f.write('Link to {}\n'.format(TARGET))
  
  print('Created new text shortcut: {} -> {}'.format(fname, TARGET))
  
  return(fname)

def processFiles(arguments):
  # creating the following for processing:
  #-link_path
  #-link_destination
  #-new_link_path
  #-new_link_destination
  
  # define a temporary output directory if none given
  if arguments.output_directory is None:
    output_directory = tempfile.mkdtemp()
    print('Output directory not specified. Outputting into {}'.format(output_directory))
  else:
    output_directory = arguments.output_directory
  
  # define list of links
  link_path_list = []
  
  # add only symlinks
  for f in arguments.files:
    if os.path.islink(f):
      link_path_list.append(f)
    else:
      print('WARNING:',f,'is not a symlink. Skipping.',file=sys.stderr)
  
  # add other symlinks in specified directories recursively
  if arguments.directory:
    for directory in arguments.directory:
      for root, dirname_list, filename_list in os.walk(directory):
        for filepath in filename_list + dirname_list:
          p = os.path.join(root, filepath)
          if os.path.islink(p):
            link_path_list.append(p)
  
  #  os.path.realpath(path): Return the canonical path of the specified filename, eliminating any symbolic links encountered in the path (if they are supported by the operating system).
  #  os.path.relpath(path, start=os.curdir): Return a relative filepath to path either from the current directory or from an optional start directory. This is a path computation: the filesystem is not accessed to confirm the existence or nature of path or start.
  #  os.readlink(path, *, dir_fd=None): Return a string representing the path to which the symbolic link points. The result may be either an absolute or relative pathname; if it is relative, it may be converted to an absolute pathname using os.path.join(os.path.dirname(path), result).
  #  os.path.normpath(path): Normalize a pathname by collapsing redundant separators and up-level references so that A//B, A/B/, A/./B and A/foo/../B all become A/B. This string manipulation may change the meaning of a path that contains symbolic links. On Windows, it converts forward slashes to backward slashes. To normalize case, use normcase().
        
  processing_tuples = []
  for link_path in link_path_list:
    orig_dir = os.path.dirname(os.path.normpath(link_path))
    link_destination_readlink = os.readlink(link_path)
    link_destination_realpath = os.path.realpath(link_path)
    
    if arguments.in_place is None:
      new_link_path = os.path.join(output_directory, os.path.relpath(link_path, start=arguments.tostrip))
    else:
      new_link_path = link_path
    
    #print(os.path.relpath(link_destination, start=arguments.tostrip))
    #new_link_destination = arguments.output_directory + os.sep + os.path.relpath(link_destination, start=arguments.tostrip)
    if arguments.use_relative_path:
      new_link_destination = os.path.relpath(link_destination_readlink, start=orig_dir)
    else:
      new_link_destination = link_destination_readlink
    processing_tuples.append((link_path, link_destination_readlink, new_link_path, new_link_destination))

  for t in processing_tuples:
    (link_path, link_destination_readlink, new_link_path, new_link_destination) = t
    if arguments.verbose:
      print('--------------------------------------------')
      print('arguments.action =', arguments.action)
      print('arguments.remove_source_files =', arguments.remove_source_files)
      print('link_path =', link_path)
      print('link_destination_readlink =', link_destination_readlink)
      print('new_link_path =', new_link_path)
      print('new_link_destination =', new_link_destination)
    if os.path.lexists(link_path):
      #if os.path.lexists(new_link_path) and arguments.force:
      
      if arguments.in_place:
        use_tempfile = True
      else:
        use_tempfile = False
        
      # if (not os.path.lexists(new_link_path)): # or arguments.force: force disabled as if the destination file is a link, it might modify the contents of the file linked to!!!
      if (not arguments.no_act):
        # do the action
        if arguments.action == 'create_shortcut_text_file':
          LINK_NAME = create_shortcut_text_file(new_link_destination, new_link_path, use_tempfile=use_tempfile)
        else:
          print('action not recognized : action = ' + arguments.action,file=sys.stderr)
          sys.exit(-1)
          
        # remove source file if requested
        if arguments.remove_source_files:
          os.remove(link_path)
      # else:
        # print('WARNING: Skipping', link_path,': destination file exists.', file=sys.stderr)
      
      # For in-place modification: If the new file creation was successful, remove the original file and rename the new file.
      if arguments.in_place:
        if arguments.in_place[0] is None:
          if (not arguments.no_act):
            os.remove(link_path)
        else:
          if (not arguments.no_act):
            os.rename(link_path, link_path + arguments.in_place[0])
        os.rename(LINK_NAME, link_path)
      
    else:
      print('WARNING: Skipping',link_path,': Path does not exist or is not accessible.', file=sys.stderr)

  return
  
  #for i in range(len(processing_tuples)):
    #if fixed_filename is not None:
      #(directory, basename) = os.path.split(fixed_filename)

      #if arguments.output_directory:
        #directory = arguments.output_directory
      
      #if basename is None:
        #continue
        
      #fixed_filename = os.path.join(directory, basename)

      #dst[i] = fixed_filename
      #if dst[i]:
        #if arguments.verbose:
          #print( arguments.action + ' ' + src[i] + ' -> ' + dst[i] )
        #if os.path.isfile(src[i]):
          #if (not os.path.isfile(dst[i])) or arguments.force:
            #if (not arguments.no_act):
              
          #if arguments.action == 'move':
            #os.rename(src[i], dst[i])
          #elif arguments.action == 'copy':
            #shutil.copy(src[i], dst[i])
          #elif arguments.action == 'copyfile':
            #shutil.copyfile(src[i], dst[i]) # when the filesystem does not support chmod permissions (i.e. Windows)
          #elif arguments.action == 'hardlink':
            #os.link(src[i], dst[i])
          #else:
            #print('action not recognized : action = ' + arguments.action,file=sys.stderr)
            #sys.exit(-1)
                
              
          #else:
            #print('WARNING: Skipping '+src[i]+' -> '+dst[i]+' : destination file exists', file=sys.stderr)
        #else:
          #print('WARNING: Skipping '+src[i]+' -> '+dst[i]+' : source file does not exist', file=sys.stderr)
      #else:
        #print('WARNING: ' + src[i] + ' could not be converted', file=sys.stderr)
  #return

def get_argument_parser():
  # command-line option handling
  parser = argparse.ArgumentParser(description = 'Convert symbolic links into text files or windows shortcuts (which can be copied to NTFS partitions).', fromfile_prefix_chars='@')
  
  parser.add_argument("-v", "--verbose", action="store_true", dest="verbose", default=False, help="Verbose: print names of files successfully renamed.")
  parser.add_argument("-n", "--no-act", action="store_true", dest="no_act", default=False, help="No Action: show what files would have been renamed.")
  parser.add_argument("-f", "--force", action="store_true", dest="force", default=False, help="Force: overwrite existing files.")
  parser.add_argument("-d", "--directory", action="append", dest="directory", help="Process this directory recursively. Multiple directories can be specified with -d DIR1 -d DIR2")
  parser.add_argument('files', action="store", nargs='*', help='input files')

  parser.add_argument("--use-relative-path", action="store_true", default=False, help="Redefine the link destination as a relative path.")

  parser.add_argument("--output-directory", default=None, action="store", help="Optional output directory (should exist). If not specified, output will go into a temporary directory.")
  #parser.add_argument("--output-directory", default=os.curdir, action="store", help="Optional output directory (should exist). If not specified, output will go into the same directory as original file.")
  
  parser.add_argument("--action", action="store", choices=['create_shortcut_text_file','hardlink','create_shortcut'], default='create_shortcut_text_file', help="create_shortcut_text_file creates a text file containing the path linked to, hardlink uses the os.link() function, create_shortcut should create a Windows shortcut (not working yet)")

  parser.add_argument('--remove-source-files',action="store_true", default=False, help="remove source files?")
  parser.add_argument('--tostrip', default=os.curdir, help='string to lstrip from link_destination')

  # Cool workaround to get an option similar to 'sed -i'. :)
  # '' -> in_place=None
  # '-i' ->  in_place=[None]
  # '-i SUFFIX' ->  in_place=[SUFFIX]
  parser.add_argument("-i", "--in-place", action='append', nargs='?', help="replace file in place (makes backup if extension supplied). Use '--' before input files if no suffix specified.",  metavar='SUFFIX')

  return parser

def main(args=None):
  parser = get_argument_parser()
  arguments = parser.parse_args() if args is None else parser.parse_args(args)
  
  if not len(sys.argv) > 1:
    parser.print_help()
  else:
    print('---------')
    print(arguments)
    print('---------')

    processFiles(arguments)
  return(0)

if __name__ == "__main__":
  sys.exit(main())
