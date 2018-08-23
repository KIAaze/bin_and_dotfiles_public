#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
A script to convert between ascii text and ascii codes in decimal, hexadecimal or binary formats.

Convert between:

  * txt: text ASCII: Z
  * dec: decimal ASCII: 90
  * bin: binary ASCII: 1011010
  * hex: hexacimal ASCII: 5A

Equivalent code::

  >>> 'a'.encode()[0]
  97
  >>> ord('a')
  97


.. todo: figure out how to make splitlines() work on input with "\\n". (i.e. interpret "typed input \\n" as newline)
'''

import re
import os
import sys
import glob
import shutil
import argparse

def txt2dec(message, separator=' '):
  ''' Convert from ASCII text to decimal ASCII codes. '''

  decodedMessage = ''

  #for ch in message:
    #print('{:03d}'.format(ord(ch)), end=separator)
  #print('')

  for idx, ch in enumerate(message):
    decodedMessage += '{:03d}'.format(ord(ch))
    if idx < len(message) - 1:
      decodedMessage += separator

  return(decodedMessage)

def dec2txt(message):
  ''' Convert from decimal ASCII codes to ASCII text. '''

  decodedMessage = ""

  # in case the numbers aren't split, but all glued together, split them into groups of 3 digit numbers
  if len(message.split())==1:
    # Mi ŝategas pitonon pro tielaj mallongigaĵoj! :)
    ord_list = [ message[i:i+3] for i in range(0,3*(len(message)//3),3) ]
  else:
    ord_list = message.split()

  for item in ord_list:
    decodedMessage += chr(int(item))

  #print('Decoded message: {}'.format(decodedMessage))
  return(decodedMessage)

def txt2bin(message, str_format='{:08b}', separator=' '):
  ''' Convert from ASCII text to binary ASCII codes. '''

  decodedMessage_list = []
  
  byte_string = message.encode()

  #for str_format in ['{:08b}', '0b{:08b}', '{:x}', '{:03d}', '{:c}']:
    #print('====> str_format = {}'.format(str_format))
    #print('--> Using a print within a for loop:')
    #for i in byte_string:
      #print(str_format.format(i), end=' ')
    #print('')

    #print('--> In a single print statement:')
    #bin_string = [str_format.format(i) for i in byte_string]
    #print(*bin_string)

  for i in byte_string:
    decodedMessage_list.append(str_format.format(i))
    
    
  decodedMessage = separator.join(decodedMessage_list)
  return(decodedMessage)

def bin2txt(message):
  ''' Convert from binary ASCII codes to ASCII text. '''

  #print('---------')
  #print(message)
  #print('---------')

  decodedMessage = ''
  
  message_lines = message.splitlines()
  # print(message_lines)
  # raise
  message_lines = message.split('\n')
  message_lines = message.split('\\n')

  # print(message_lines)
  # raise
  
  for line_idx, line in enumerate(message_lines):
    # print((line_idx, line))
    #continue
    line_clean = line.replace('\n', '').replace('0b','').replace(' ','')
    
    line_split = [ line_clean[i:i+8] for i in range(0, len(line_clean), 8) ]
    
    for binletter in line_split:
      decodedMessage += chr(int('0b'+binletter, base=2))

    if line_idx < len(message_lines) - 1:
      decodedMessage += '\n'
    
  #print('Decoded message:\n{}'.format(decodedMessage))

  return decodedMessage

def txt2hex(message, separator=' '):
  ''' Convert from ASCII text to hexadecimal ASCII codes. '''
  
  message_out_list = []
  for letter in message:
    message_out_list.append('{:02x}'.format(ord(letter)))
  message_out = separator.join(message_out_list)
  return(message_out)

def hex2txt(message, separator=''):
  ''' Convert from hexadecimal ASCII codes to ASCII text. '''
  
  message_out_list = []
  
  line_clean = message.replace('0x','').replace(' ','').replace('\t','')
    
  line_split = [ line_clean[i:i+2] for i in range(0, len(line_clean), 2) ]
    
  for hexletter in line_split:
    message_out_list.append(chr(int('0x'+hexletter, base=16)))
  
  message_out = separator.join(message_out_list)
  return(message_out)

def main():
  ''' parser setup '''  
  parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
  subparsers = parser.add_subparsers(help='Available subcommands', dest='chosen_subcommand')

  parser.add_argument('--verbose', '-v', action='count', dest='verbosity', default=0)
  parser.add_argument('-c', '--combine-args', help='Combine all arguments into a single string.', action='store_true')

  parser.add_argument('-i', '--infile', type=argparse.FileType('r'), help='Specify an input file.')

  parser_txt2dec = subparsers.add_parser('txt2dec', help=txt2dec.__doc__)
  parser_txt2dec.add_argument('args', nargs='*', metavar='TXTSTR', help='Messages to decrypt.')
  parser_txt2dec.set_defaults(func=txt2dec)

  parser_dec2txt = subparsers.add_parser('dec2txt', help=dec2txt.__doc__)
  parser_dec2txt.add_argument('args', nargs='*', metavar='DECSTR', help='Messages to decrypt.')
  parser_dec2txt.set_defaults(func=dec2txt)

  parser_txt2bin = subparsers.add_parser('txt2bin', help=txt2bin.__doc__)
  parser_txt2bin.add_argument('args', nargs='*', metavar='TXTSTR', help='Messages to decrypt.')
  parser_txt2bin.set_defaults(func=txt2bin)

  parser_bin2txt = subparsers.add_parser('bin2txt', help=bin2txt.__doc__)
  parser_bin2txt.add_argument('args', nargs='*', metavar='BINSTR', help='Messages to decrypt.')
  parser_bin2txt.set_defaults(func=bin2txt)

  parser_txt2hex = subparsers.add_parser('txt2hex', help=txt2hex.__doc__)
  parser_txt2hex.add_argument('args', nargs='*', metavar='TXTSTR', help='Messages to decrypt.')
  parser_txt2hex.set_defaults(func=txt2hex)

  parser_hex2txt = subparsers.add_parser('hex2txt', help=hex2txt.__doc__)
  parser_hex2txt.add_argument('args', nargs='*', metavar='HEXSTR', help='Messages to decrypt.')
  parser_hex2txt.set_defaults(func=hex2txt)

  allargs = parser.parse_args()

  if allargs.verbosity >= 2:
    print(allargs)
  
  if allargs.chosen_subcommand:

    if allargs.infile is None:
      if len(allargs.args) == 0:
        message = input("Enter string of letters or numbers to process: ")
        message_list = [message]
      elif allargs.combine_args:
        message_list = [' '.join(allargs.args)]
      else:
        message_list = allargs.args
    
      if allargs.verbosity >= 3:
        print('=============')
        print('message_list:')
        print('-------------')
        for m in message_list:
          print(m)
          print('-------------')
        print('=============')

      for message in message_list:
        if allargs.verbosity:
          print('==> Processing {}'.format(message))
        result = allargs.func(message)
        if allargs.verbosity:
          print("Conversion result:")
        print(result)

    else:
      if allargs.verbosity:
        print('==> Processing {}'.format(allargs.infile.name))
      message = allargs.infile.read()
      result = allargs.func(message)
      if allargs.verbosity:
        print("Conversion result:")
      print(result)
  
  else:
    parser.print_help()
  
  return

if __name__ == "__main__":
  main()
