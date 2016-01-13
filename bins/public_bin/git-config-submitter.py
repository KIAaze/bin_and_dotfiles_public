#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# <pep8-80 compliant>

# .. todo:: global config? But then I wouldn't need this script. ;)
# .. todo:: GUI for name selection? list of previously used name+mail pairs?

import re
import sys
import argparse
import textwrap
import subprocess


def main():

    # argparse

    description_string = '''
    Configure name+mail in git more easily.

    Example 1:
    Select a name+mail pair from one of the previous commits:
      git-config-submitter.py

    Example 2:
    Pass a name+mail pair using the format used in git log output,
    i.e. "name <mail>":
      git-config-submitter.py "first last <user@host>"
    '''

    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=textwrap.dedent(description_string))

    parser.add_argument('submitter', nargs='?')
    args = parser.parse_args()

    # default name+mail values
    an = None
    ae = None

    if args.submitter:  # if submitter specified, parse it
        s = sys.argv[1]
        p = re.compile('(.*) <(.*)>')
        m = p.match(s)
        if m:
            an, ae = m.groups()
            print(an)
            print(ae)
        else:
            raise Exception(textwrap.dedent('''
                Invalid name/mail string.
                It should be of the form: "name <mail>"'''))
    else:  # if no submitter specified, get it from log
        author_name_list = subprocess.check_output(
            ['git', 'log', '--pretty=format:%an'], universal_newlines=True)
        author_name_list = author_name_list.split('\n')
        author_mail_list = subprocess.check_output(
            ['git', 'log', '--pretty=format:%ae'], universal_newlines=True)
        author_mail_list = author_mail_list.split('\n')
        print(author_name_list[0:3])
        print(author_mail_list[0:3])

        for an_tmp, ae_tmp in zip(author_name_list, author_mail_list):
            ans = input('Use {} <{}>? (y/n): '.format(an_tmp, ae_tmp))
            if ans == 'y':
                an = an_tmp
                ae = ae_tmp
                break

    # apply name+mail
    if an is not None and ae is not None:
        print('Setting default commiter to:\n  {} <{}>'.format(an, ae))
        cmd = ['git', 'config', 'user.name', '{}'.format(an)]
        subprocess.check_call(cmd)
        cmd = ['git', 'config', 'user.email', '{}'.format(ae)]
        subprocess.check_call(cmd)

        print('You may fix the identity used for the last commit with:')
        print('  git commit --amend --reset-author')
    else:
        print('Nothing changed.')

    return

if __name__ == '__main__':
    main()
