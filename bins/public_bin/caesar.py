#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
Caesar cypher cracking script.
The dictionary attack requires the aspell module from https://pypi.python.org/pypi/aspell-python-py3/1.15
'''

import re
import sys
import argparse
import textwrap

def caesar1(plaintext, shift):

  alphabet=["a","b","c","d","e","f","g","h","i","j","k","l",
  "m","n","o","p","q","r","s","t","u","v","w","x","y","z"]

  #Create our substitution dictionary
  dic={}
  for i in range(0,len(alphabet)):
    dic[alphabet[i]]=alphabet[(i+shift)%len(alphabet)]

  #Convert each letter of plaintext to the corrsponding
  #encrypted letter in our dictionary creating the cryptext
  ciphertext=""
  for l in plaintext.lower():
    if l in dic:
      l=dic[l]
    ciphertext+=l

  return ciphertext

def caesar2(message_in, key, encrypt=True):
  message_out = ''
  
  if not encrypt:
    key = -key
  
  for idx, letter in enumerate(message_in):
    if ord('a') <= ord(letter) <= ord('z'):
      new_letter_chr = chr( ord('a') + ((ord(letter) - ord('a')) + key)%26 )
    elif ord('A') <= ord(letter) <= ord('Z'):
      new_letter_chr = chr( ord('A') + ((ord(letter) - ord('A')) + key)%26 )
    else:
      new_letter_chr = letter
    message_out += new_letter_chr
  return(message_out)

def bruteforce_caesar(message_in):
  message_out = ''
  for key in range(26):
    message_out += 80*'=' + '\n'
    message_out += 'key = ' + str(key) + '\n'
    message_out += 80*'=' + '\n'
    message_out += caesar2(message_in, key)
    message_out += '\n'
  return(message_out)

def bruteforce_caesar_using_dictionary(message_in, verbosity=0, reverse_output=False):
  import aspell
  import numpy
  spellchecker = aspell.Speller('lang', 'en')
  spellchecker.setConfigKey('ignore-case', True)
  
  score_list = []
  message_out_list = []
  incorrect_words_list = []
  number_of_words = []
  for key in range(26):
    message_out = caesar2(message_in, key)
    message_out_list.append(message_out)
    
    score = 0
    
    # split text into words
    #word_list = message_out.split()
    word_list = re.findall(r'\w+', message_out)
    
    incorrect_words = []
    for word in word_list:
      if spellchecker.check(word.lower()):
        score += 1
      else:
        incorrect_words.append(word)
    score_list.append(score)
    incorrect_words_list.append(incorrect_words)
    number_of_words.append(len(word_list))
    
    #print('key = {} -> score = {}'.format(key, score))
  
  
  #print(list(reversed(sorted(score_list))))
  #print(list(reversed(numpy.argsort(score_list))))
  #raise
  
  # create final log output
  if reverse_output:
    sorted_key_list = numpy.argsort(score_list)
  else:
    sorted_key_list = reversed(numpy.argsort(score_list))
  
  summary = ''
  for key in sorted_key_list:
    summary += 80*'=' + '\n'
    summary += 'key = {} -> score = {}/{}\n'.format(key, score_list[key], number_of_words[key])
    summary += 80*'=' + '\n'
    summary += message_out_list[key]
    
    if verbosity > 0:
      summary += 40*'-' + '\n'
      summary += 'Incorrect words:\n'
      summary += 40*'-' + '\n'
      for i in incorrect_words_list[key]:
        summary += i + '\n'
    
    summary += '\n'
  return(summary)

def main():
  parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter,
    description=textwrap.dedent('''\
...         Example usage:
...         --------------
...         echo "Hello world!" | %(prog)s --encrypt --key 4
...         %(prog)s --encrypt --key 4 infile.txt
...         %(prog)s --encrypt --key 4 infile.txt outfile.txt
...         '''))
  parser.add_argument("-k", "--key", default=0, type=int)
  group = parser.add_mutually_exclusive_group(required=True)
  group.add_argument("-e", "--encrypt", action='store_true')
  group.add_argument("-d", "--decrypt", action='store_true')
  group.add_argument("-b", "--brute-force", action='store_true')
  group.add_argument("-s", "--dictionary", action='store_true')
  parser.add_argument('-v', '--verbose', action="count", dest="verbosity", default=0, help='verbosity level')
  parser.add_argument('-r', '--reverse', action="store_true", help='reverse output order for dictionary attack')
  parser.add_argument('infile', nargs='?', type=argparse.FileType('r'),
                      default=sys.stdin)
  parser.add_argument('outfile', nargs='?', type=argparse.FileType('w'),
                      default=sys.stdout)
  
  args = parser.parse_args()
  
  if args.brute_force:
    args.outfile.write(bruteforce_caesar(args.infile.read()))
  elif args.dictionary:
    args.outfile.write(bruteforce_caesar_using_dictionary(args.infile.read(), verbosity=args.verbosity, reverse_output=args.reverse))
  else:
    args.outfile.write(caesar2(args.infile.read(), args.key, args.encrypt))
  
  return 0

def test_caesar1():
  #Example useage
  plaintext = "user: toto MDP: ******"
  print("Plaintext:", plaintext)
  print("Cipertext:", caesar1(plaintext, 3))
  #This will result in:
  #Plaintext: the cat sat on the mat
  #Cipertext: wkh fdw vdw rq wkh pdw

if __name__ == '__main__':
  main()
  #test_caesar1()
