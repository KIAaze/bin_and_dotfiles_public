#!/usr/bin/env python
import sys
import struct

#a='2d'
#bytes.fromhex('2Ef0 F1f2  ')
#bytes().fromhex(a)

outfile = sys.argv[1]

message = raw_input("Enter message to encode: ")
#message = 'ab.c.defghi.jklmnopqrstuvwxyzABCDmessage = raw_input("Enter message to encode:and points. OK'

s=message
snew=''
for i in s:
  snew += 3*i

message=snew

NBlocksX = 5
NBlocksY = 5

BlockHeight = 15
BlockWidth = 15

#BlockHeight = 1
#BlockWidth = 1

pictureHeight = NBlocksX*BlockHeight
pictureWidth = NBlocksY*BlockWidth

nBytesPerColor = 3
message_length = nBytesPerColor*NBlocksX*NBlocksY

message_adapted = message[:message_length]
if len(message_adapted)<message_length:
  message_adapted += (message_length-len(message_adapted))*' '

print('Writing to '+outfile)
print('message_adapted:\n'+"'"+message_adapted+"'")
print('len(message_adapted) = '+str(len(message_adapted)))
print('message_length = '+str(message_length))

#f=open('tmp.bin','wb')
#import struct
#data = struct.pack('i', 45)
#f.write(data)

#pictureHeight_bytes = format(pictureHeight,'x').encode()
#pictureWidth_bytes = format(pictureWidth,'x').encode()

pictureHeight_bytes = struct.pack('B', pictureHeight)
pictureWidth_bytes = struct.pack('B', pictureWidth)

# open file
f = open(outfile,'wb')

# write header, with picture width and height
f.write(b'\x42\x4d\x1e\x18\x00\x00\x00\x00\x00\x00\x36\x00\x00\x00\x28\x00')
f.write(b'\x00\x00' + pictureWidth_bytes + b'\x00\x00\x00' + pictureHeight_bytes + '\x00\x00\x00\x01\x00\x18\x00\x00\x00')
f.write(b'\x00\x00\xe8\x17\x00\x00\x13\x0b\x00\x00\x13\x0b\x00\x00\x00\x00')
f.write(b'\x00\x00\x00\x00\x00\x00')

#for i in range(BlockHeight):
  #for j in range(nBytesPerColor*BlockWidth):
    #f.write('H'.encode())
  #for j in range(nBytesPerColor*BlockWidth):
    #f.write('e'.encode())
  #for j in range(nBytesPerColor*BlockWidth):
    #f.write('l'.encode())
  #f.write(b'\x00')

#for i in range(BlockHeight):
  #for j in range(nBytesPerColor*BlockWidth):
    #f.write(b'\xCC')
  #for j in range(nBytesPerColor*BlockWidth):
    #f.write(b'\xBB')
  #for j in range(nBytesPerColor*BlockWidth):
    #f.write(b'\xAA')
  #f.write(b'\x00')

#for i in range(BlockHeight):
  #for j in range(nBytesPerColor*BlockWidth):
    #f.write(b'\xFF')
  #for j in range(nBytesPerColor*BlockWidth):
    #f.write(b'\xEE')
  #for j in range(nBytesPerColor*BlockWidth):
    #f.write(b'\xDD')
  #f.write(b'\x00')

#lol=[message_adapted[i:i+nBytesPerColor] for i in range(0, len(message_adapted), nBytesPerColor)]
#print(lol)

data = bytes()

for i in range(NBlocksX):
  for k in range(BlockHeight):
    for j in range(NBlocksY):
      current_block = nBytesPerColor*(NBlocksY*i+j)
      B = message_adapted[current_block+0]
      G = message_adapted[current_block+1]
      R = message_adapted[current_block+2]
      #print('B='+B)
      #print('G='+G)
      #print('R='+R)
      data = BlockWidth*(B+G+R)
      #print(data)
      N = f.write(data.encode())
      #print(N)
    f.write((pictureWidth%4)*b'\x00')

#for i in range(0, len(message_adapted), nBytesPerColor):
  #message[]
  

#for (R,G,B) in message:
  #print('R='+R)
  #print('G='+G)
  #print('B='+B)

#>>> f.close()
#>>> line = '1234567890'
#>>> n = 2
#>>> [line[i:i+n] for i in range(0, len(line), n)]
#['12', '34', '56', '78', '90']
#>>> n = 3
#>>> [line[i:i+n] for i in range(0, len(line), n)]
#['123', '456', '789', '0']
#>>>

#f.write(message.encode())

# close file
f.close()

#cut string into groups of 3 characters (each character = 1 byte = 2  hex chars, 3 chars = one RGB color)
