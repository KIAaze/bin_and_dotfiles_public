#!/usr/bin/env python3

def check(v, e, f, p, h, verbose=True):
  if verbose:
    print('v={}, e={}, f={}, p={}, h={}'.format(v,e,f,p,h))
  c_0 = (5*p+6*h == 2*e)
  c_1 = (p+h == f)
  c_2 = (v-e+f == 2)
  c_all = c_0 and c_1 and c_2
  if verbose:
    print(c_0, c_1, c_2, c_all)
  return c_all

def calc_p_h(v, e, f):
  print(v,e,f)
  for p in range(0, f+1):
    h = f - p
    if check(v, e, f, p, h, verbose=False):
      check(v, e, f, p, h, verbose=True)

print('== c60 ==')
v=60
e=90
f=32
calc_p_h(v, e, f)
p=12
h=20
check(v, e, f, p, h, verbose=True)

print('== c70 ==')
v=70
e=105
f=37
calc_p_h(v, e, f)
p=12
h=25
check(v, e, f, p, h, verbose=True)

print('== c78 ==')
v=78
e=117
f=41
calc_p_h(v, e, f)
p=12
h=29
check(v, e, f, p, h, verbose=True)

print('== c75 ==')
v=75
e=50+65
f=2+e-v
calc_p_h(v, e, f)
