#!/usr/bin/env python3
# A very basic Mr.Robot-like terminal with a prompt before every line. :)
# (This is still one of my biggest disappointments from this otherwise very good series. :/ )
# TODO: Could possibly be improved with readline for history handling.

import subprocess

def main():
  PS1 = 'root@elliot$ '
  while(True):
    cmd = input(PS1)
    if cmd:
      cmd_list = cmd.split()
      try:
        out = subprocess.check_output(cmd_list, universal_newlines=True, stderr=subprocess.STDOUT)
        for i in out.split('\n'):
          print(PS1 + i)
      except subprocess.CalledProcessError as err:
        print(PS1 + err.output)
      except:
        print('{}: command not found'.format(cmd_list[0]))

if __name__ == "__main__":
  main()
