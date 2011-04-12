#!/usr/bin/env python
# -*- coding: utf-8 -*-
# unminimize all windows

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

if __name__ == '__main__':
    main()
