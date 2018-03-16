#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# <pep8-80 compliant>

# .. todo:: letter patterns/statistics attack

import sys
import argparse

def vigenere(decrypted_message, key, encrypt=True, start_chr=' ', end_chr='~',
             lower_case=False):

    start_ord = ord(start_chr)  # 32
    end_ord = ord(end_chr)  # 126
    period = end_ord - start_ord + 1  # 95

    encrypted_message = ''
    for idx, letter in enumerate(decrypted_message):
        if lower_case:
            letter = letter.lower()
        if start_ord <= ord(letter) <= end_ord:
            current_key = key[idx % len(key)]
            letter_delta = ord(letter) - start_ord
            key_delta = ord(current_key) - start_ord

            if encrypt:
                new_letter_ord = (letter_delta + key_delta) % period
            else:
                new_letter_ord = (letter_delta - key_delta) % period

            new_letter_ord += start_ord
            new_letter_chr = chr(new_letter_ord)
        else:
            new_letter_chr = letter
        encrypted_message += new_letter_chr
    return encrypted_message


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-k", "--key", default='password')
    parser.add_argument("--start_chr", default=' ')
    parser.add_argument("--end_chr", default='~')
    parser.add_argument("--lower-case", action='store_true')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("-e", "--encrypt", action='store_true')
    group.add_argument("-d", "--decrypt", action='store_true')
    parser.add_argument('infile', nargs='?', type=argparse.FileType('r'),
                        default=sys.stdin)
    parser.add_argument('outfile', nargs='?', type=argparse.FileType('w'),
                        default=sys.stdout)

    args = parser.parse_args()
    # print(args)

    args.outfile.write(vigenere(args.infile.read(), args.key, args.encrypt,
                                args.start_chr, args.end_chr, args.lower_case))

    return 0

if __name__ == '__main__':
    main()
