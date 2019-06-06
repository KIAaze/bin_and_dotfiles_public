#!/usr/bin/env python3

# enter the matrix screensaver+music starter B)
# Works for dual monitor setup.
# TODO: clean up + improve

# based on a script by Jacob Vlijm
#source: https://askubuntu.com/questions/702071/move-windows-to-specific-screens-using-the-command-line

import subprocess
import sys
import time

# just a helper function, to reduce the amount of code
get = lambda cmd: subprocess.check_output(cmd).decode("utf-8")

# get the data on all currently connected screens, their x-resolution
screendata = [l.split() for l in get(["xrandr"]).splitlines() if " connected" in l]
print('screendata = {}'.format(screendata))

screendata = sum([[(w[0], s.split("+")[-2], s.split("+")[-1]) for s in w if s.count("+") == 2] for w in screendata], [])

print('screendata = {}'.format(screendata))

def get_class(classname):
    # function to get all windows that belong to a specific window class (application)
    w_list = [l.split()[0] for l in get(["wmctrl", "-l"]).splitlines()]
    
    #for w in w_list:
      #print('===> w = {}'.format(w))
      #print(get(["xprop", "-id", w]))
    
    return [w for w in w_list if classname in get(["xprop", "-id", w])]

#scr = sys.argv[2]

#try:
    ## determine the left position of the targeted screen (x)
    ##print('{}'.format([sc for sc in screendata if sc[0] == scr]))
    #pos = [sc for sc in screendata if sc[0] == scr][0]
    #print('pos = {}'.format(pos))
#except IndexError:
    ## warning if the screen's name is incorrect (does not exist)
    #print(scr, "does not exist. Check the screen name")
#else:
    #for idx, w in enumerate(get_class(sys.argv[1])):
        #print('===> w = {}'.format(w))
        ## first move and resize the window, to make sure it fits completely inside the targeted screen
        ## else the next command will fail...
        #subprocess.Popen(["wmctrl", "-ir", w, "-e", "0,"+str(int(pos[1])+100)+",100,300,300"])
        ## maximize the window on its new screen
        #subprocess.Popen(["xdotool", "windowsize", "-sync", w, "100%", "100%"])

cmd = ['/usr/lib/xscreensaver/glmatrix', '-fog', '-waves', '-rotate', '-clock']
p1 = subprocess.Popen(cmd)
time.sleep(0.5)
p2 = subprocess.Popen(cmd)
time.sleep(0.5)

for idx, w in enumerate(get_class('glmatrix')[0:2]):
    print('===> w = {}'.format(w))
    pos = screendata[idx]
    print('pos = {}'.format(pos))
    # first move and resize the window, to make sure it fits completely inside the targeted screen
    # else the next command will fail...
    cmd = ["wmctrl", "-ir", w, "-e", "0," + str(int(pos[1])+100) + "," + str(int(pos[2])+100) + ",300,300"]
    print(' '.join(cmd))
    #subprocess.Popen(cmd, check=True)
    subprocess.run(cmd, check=True)
    # maximize the window on its new screen
    #subprocess.Popen(["xdotool", "windowsize", "-sync", w, "100%", "100%"])

    cmd = ['wmctrl', '-i', '-r', w, '-b', 'add,fullscreen']
    print(' '.join(cmd))
    subprocess.run(cmd, check=True)
    
    cmd = ['wmctrl', '-i', '-a', w]
    print(' '.join(cmd))
    subprocess.run(cmd, check=True)

while p1.poll() == None and p2.poll() == None:
  pass

print('Killing processes...')
p1.kill()
p2.kill()
print('DONE')
