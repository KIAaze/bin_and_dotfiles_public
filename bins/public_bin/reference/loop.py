#!/usr/bin/env python
# -*- coding: utf-8 -*-

a=[3,
5,
7]

for i in range(10):
  ok=1
  for j in range(len(a)):
    if i==a[j]:
      ok=0
      break
  if ok==1:
    print i
