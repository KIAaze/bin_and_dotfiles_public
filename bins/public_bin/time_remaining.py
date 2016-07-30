#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
import argparse
import datetime

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument('deadline_date')
  parser.add_argument('deadline_time', nargs='?', default='00:00')
  args = parser.parse_args()
  
  pattern_date = re.compile('(\d\d\d\d)-(\d\d)-(\d\d)')
  pattern_time = re.compile('(\d\d):(\d\d)')
  
  match_date = pattern_date.fullmatch(args.deadline_date)
  match_time = pattern_time.fullmatch(args.deadline_time)
  
  if match_date:
    Y = int(match_date.group(1))
    M = int(match_date.group(2))
    D = int(match_date.group(3))
  else:
    raise Exception('Date should be in YYYY-MM-DD format.')
  
  if match_time:
    h = int(match_time.group(1))
    m = int(match_time.group(2))
  else:
    raise Exception('Time should be in hh:mm format.')
  
  now = datetime.datetime.now()
  deadline = datetime.datetime(Y,M,D,h,m)
  time_left = deadline - now

  m, s = divmod(time_left.seconds, 60)
  h, m = divmod(m, 60)
  print('You have {} days, {} hours and {} minutes left.'.format(time_left.days, h, m))
  
  return

if __name__ == "__main__":
  main()
