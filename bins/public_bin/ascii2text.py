#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Convertion from ASCII codes to text

message = raw_input("Enter ASCII codes: ")

decodedMessage = ""

# in case the numbers aren't spli, but all glued together, split them into groups of 3 digit numbers
if len(message.split())==1:
  # Mi ŝategas pitonon pro tielaj mallongigaĵoj! :)
  ord_list = [ message[i:i+3] for i in range(0,3*(len(message)//3),3) ]
else:
  ord_list = message.split()

for item in ord_list:
  decodedMessage += chr(int(item))

print "Decoded message:", decodedMessage
