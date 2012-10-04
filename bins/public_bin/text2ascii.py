#!/usr/bin/env python
# Convertion from text to ASCII codes

message = raw_input("Enter message to encode: ")

print "Decoded string (in ASCII):"
for ch in message:
   print ord(ch),
