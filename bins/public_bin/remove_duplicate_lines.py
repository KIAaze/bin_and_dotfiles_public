#!/usr/bin/env python3

# http://stackoverflow.com/questions/11532157/unix-removing-duplicate-lines-without-sorting

import os
import sys
import argparse
import tempfile
import shutil

def main():
    
    parser = argparse.ArgumentParser(description='Skip/remove duplicate lines without sorting')
    #parser.add_argument('infile', type=open)
    parser.add_argument('infile', nargs='+')
    parser.add_argument('-i', '--in-place', action='store_true')
    args = parser.parse_args()
    
    #print(args)
    #sys.exit()

    for infilename in args.infile:
        if not os.path.isfile(infilename):
            print('{}: Not a file. Skipping.'.format(infilename))
            continue

        if args.in_place:
            outfile = tempfile.TemporaryFile('r+')
        else:
            outfile = sys.stdout

        unique_lines = []
        duplicate_lines = []

        with open(infilename, 'r') as infile:
            #for line in sys.stdin:
            for line in infile:
                if line.strip() and line.strip()[0]!='#':
                    if line in unique_lines:
                        duplicate_lines.append(line)
                    else:
                        unique_lines.append(line)
                        outfile.write(line)
                else:
                    outfile.write(line)

        # optionally do something with duplicate_lines

        #print('=============')
        if args.in_place:
            outfile.seek(0)
            #for l in outfile:
                #sys.stdout.write(l)
            
            with open(infilename, 'w') as infile:
                shutil.copyfileobj(outfile, infile)

if __name__ == "__main__":
  main()
