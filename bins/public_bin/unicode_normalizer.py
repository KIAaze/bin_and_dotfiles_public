#!/usr/bin/env python3

# From: http://billposer.org/Linguistics/Computation/UnicodeNormalization.html
# cf also: http://unicode.org/reports/tr15/

# Easy way to locate problematic characters in a .bib file:
# -Open in kate
# -save with latin1 (ISO-8859-1) encoding under a different filename (ignore warning)
# -compare original and new file with meld or similar

# Note: bibtool -i IN -o OUT does not fix encoding problems.

import sys
import codecs
import unicodedata
(utf8_encode, utf8_decode, utf8_reader, utf8_writer) = codecs.lookup('utf-8')
outfile = utf8_writer(sys.stdout)
infile = utf8_reader(sys.stdin)
#outfile.write(unicodedata.normalize('NFD',infile.read()))
#outfile.write(unicodedata.normalize('NFC',infile.read()))
#outfile.write(unicodedata.normalize('NFKD',infile.read()))
outfile.write(unicodedata.normalize('NFKC',infile.read()))
sys.exit(0)
