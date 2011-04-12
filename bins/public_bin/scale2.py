#!/usr/bin/env python
# -*- coding: utf-8 -*-
# scale all windows, including minimized, but don't reminimize them

import sys
sys.path.append("~/bin/public_bin")
from scale import *

def main():
    # ************************************************************************
    # Unminimize all minimized viewport windows
    # ************************************************************************
    eligibleWindows = get_eligible_windows()
    ineligibleWindows = get_ineligible_windows()
    if eligibleWindows:
        minimizedWindows = determine_minimized(eligibleWindows)
    else:
        os._exit(0)
    doUnmin = do_unmin()
    if doUnmin == True or minimizedWindows == eligibleWindows:
        if minimizedWindows:
            for window in minimizedWindows:
                window_command(window, 'unminimize')
    else:
        minimizedWindows = []
    # ************************************************************************
    # Launch the Scale plugin of the Compiz window manager
    # ************************************************************************
    # Aside from ESCaping out, Scale will exit upon one of three actions:
    #    Selecting a tasklist window, closing the last tasklist window, or
    #    showing the desktop
    # Launch Scale
    scale=subprocess.call('dbus-send --type=method_call ' +
        '--dest=org.freedesktop.compiz ' +
    # ------------------------------------------------------------------------
    # Update this line as desired according to instructions at the top of this
    #    script
        '/org/freedesktop/compiz/scale/allscreens/initiate_key '
    # ------------------------------------------------------------------------
        + ' org.freedesktop.compiz.activate string:\'root\' ' +
        'int32:`xwininfo -root | grep id: | awk \'{ print $4 }\'`', shell=True)
    # Activating a non-tasklist window in this script ensures that Scale will
    #    always generate an 'active_window_changed' event when it exits
    if ineligibleWindows:
        firstIneligibleWin = ineligibleWindows[0]
        window_command(firstIneligibleWin, 'activate')
    else:
    #   In this case, the active window will be the last window unminimized
        firstIneligibleWin = ""

if __name__ == '__main__':
    main()
