#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re
import sys
import argparse
import tempfile
import textwrap
import subprocess

def main():
  parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description=textwrap.dedent('''\
    Split the pathname path into a pair (root, ext) such that root + ext == path, and ext is empty or begins with a period and contains at most one period.
    Leading periods on the basename are ignored;

    Examples:
      ------------------------------
      $ splitext.py file.py
      file
      $ splitext.py -e file.py
      .py
      $ splitext.py .cshrc
      .cshrc
      $ splitext.py -e .cshrc

      $ splitext.py /dir/file.py
      /dir/file
      $ splitext.py -e /dir/file.py
      .py
      $ splitext.py /dir/.cshrc
      /dir/.cshrc
      $ splitext.py -e /dir/.cshrc

      Bash alternatives:
      cf: https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
      filename=$(basename -- "$fullfile")
      extension="${filename##*.}"
      filename="${filename%.*}"
      filename="${fullfile##*/}"

      .. todo:: splitext.sh ?
      ------------------------------
    '''))
  parser.add_argument('path')
  parser.add_argument('-e', '--extension', action='store_true', help='If set, print extension only, else print root only.')
  parser.add_argument('-v', '--verbose', action="count", dest="verbosity", default=0, help='verbosity level')
  args = parser.parse_args()

  (root, ext) = os.path.splitext(args.path)
  if args.extension:
    print(ext)
  else:
    print(root)
  
  return 0

if __name__ == '__main__':
  main()
