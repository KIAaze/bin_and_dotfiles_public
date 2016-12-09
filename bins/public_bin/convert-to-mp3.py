#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re
import sys
import argparse
import tempfile
import subprocess
import textwrap

# .. todo:: implement copying while keeping directory subtrees
# .. todo:: implement config file for easy copying to some default dirs, such as external mpb3-player...
# .. todo:: lookup existing tools for this, maybe even with GUIs..., find/create good all2mp3 converter/copier...
# .. todo:: bash: possible to do this: ${i%(.m4a,.ogg,.opus,.webm,etc)} ?
# .. todo:: get a player with ogg support...

def main():
  parser = argparse.ArgumentParser(
            formatter_class=argparse.RawDescriptionHelpFormatter,
            description=textwrap.dedent('''\
              Convert non-mp3 audio files to .mp3 audio files.
              
              Example usage:
                $ find . -type f -name "*.webm" -exec convert-to-mp3.py {} \;
            '''))
  parser.add_argument('infile', nargs='+')
  parser.add_argument('-d', '--destination', help='Destination directory. By default, the output file is written to the same directory as the source file.')
  parser.add_argument('-r', '--remove', action='store_true', help='Remove source file after conversion.')
  parser.add_argument('-i', '--ignore-errors', action='store_true', help='Ignore errors, i.e. continue on conversion errors.')
  parser.add_argument('-e', '--replace-extension', action='store_true', help='By default, for an input file "source.ext" the name of the new file is simply "source.ext.mp3". Use this option to get "source.mp3" instead.')
  parser.add_argument('-v', '--verbose', action="count", dest="verbosity", default=0, help='verbosity level')
  args = parser.parse_args()
  print(args)
  
  extension_list = ['.ogg', '.m4a', '.opus', '.webm', '.flac']
  
  for infile in args.infile:
    print('===> processing {}'.format(infile))
    (root, ext) = os.path.splitext(infile)
    if ext in extension_list:
      if args.replace_extension:
        outfile = root + '.mp3'
      else:
        outfile = infile + '.mp3'
      if args.destination:
        outfile = os.path.join(args.destination, os.path.basename(outfile))
      print('{} -> {}'.format(infile, outfile))
      cmd = ['avconv', '-i', infile, outfile]
      print(' '.join(cmd))
      completed_process = subprocess.run(cmd, check=not args.ignore_errors)
      print('returncode = {}'.format(completed_process.returncode))
      if args.remove and completed_process.returncode == 0:
        cmd = ['rm', '--verbose', infile]
        print(' '.join(cmd))
        ret = subprocess.run(cmd, check=not args.ignore_errors)
    else:
      print('Skipping {}. Unsupported extension: "{}". Supported extensions: {}'.format(infile, ext, extension_list))
  
  return 0

if __name__ == '__main__':
  main()
