#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
import os
import sys
import glob
import shutil
import argparse

def text2ascii(message, separator=' '):
	''' Conversion from text to ASCII codes '''
		
	print("Decoded string (in ASCII):")
	for ch in message:
		print('{:03d}'.format(ord(ch)), end=separator)
	print('')

def ascii2text(message):
  ''' Conversion from ASCII codes to text '''

  decodedMessage = ""

  # in case the numbers aren't split, but all glued together, split them into groups of 3 digit numbers
  if len(message.split())==1:
    # Mi ŝategas pitonon pro tielaj mallongigaĵoj! :)
    ord_list = [ message[i:i+3] for i in range(0,3*(len(message)//3),3) ]
  else:
    ord_list = message.split()

  for item in ord_list:
    decodedMessage += chr(int(item))

  print('Decoded message: {}'.format(decodedMessage))

def text2bin(message):
  ''' Convert an ASCII string to binary (and other formats). '''
  
  byte_string = message.encode()

  for str_format in ['{:08b}', '0b{:08b}', '{:x}', '{:03d}', '{:c}']:
    print('====> str_format = {}'.format(str_format))
    print('--> Using a print within a for loop:')
    for i in byte_string:
      print(str_format.format(i), end=' ')
    print('')

    print('--> In a single print statement:')
    bin_string = [str_format.format(i) for i in byte_string]
    print(*bin_string)

def main():
  ''' parser setup '''
  
  parser = argparse.ArgumentParser(description='A script to convert between ascii text and ascii codes in decimal, hexadecimal or binary formats.')
  subparsers = parser.add_subparsers(help='Available subcommands', dest='chosen_subcommand')

  parser_text2bin = subparsers.add_parser('text2bin', help=text2bin.__doc__)
  parser_text2bin.add_argument('args', nargs='*', metavar='STR')
  parser_text2bin.set_defaults(func=text2bin)

  parser_ascii2text = subparsers.add_parser('ascii2text', help=ascii2text.__doc__)
  parser_ascii2text.add_argument('args', nargs='*', metavar='NUM')
  parser_ascii2text.set_defaults(func=ascii2text)

  parser_text2ascii = subparsers.add_parser('text2ascii', help=text2ascii.__doc__)
  parser_text2ascii.add_argument('args', nargs='*', metavar='STR')
  parser_text2ascii.set_defaults(func=text2ascii)

  allargs = parser.parse_args()
  
  if allargs.chosen_subcommand:
    if len(allargs.args) == 0:
      message = input("Enter string of letters or numbers to process: ")
      allargs.func(message)
    else:
      for message in allargs.args:
        print('==> Processing {}'.format(message))
        allargs.func(message)
  else:
    parser.print_help()
  
  return

if __name__ == "__main__":
  main()
