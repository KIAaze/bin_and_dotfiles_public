#!/bin/sh
pacman -Qi | awk $@ '
    BEGIN {
        units["B"] = 0
        units["KiB"] = 1
        units["MiB"] = 2
        units["GiB"] = 3
        if (unit == "") unit = "MiB"
        if (min == "") min = 50
        if (pad == "") pad = 10
    }
    /^Name/ {name=$3}
    /^Installed Size/ {
        size = (int($4) * 1024^units[$5]) / 1024^units[unit]
        if (size > min) printf "% *.1f %s %s\n", pad, size, unit, name
    }
' | sort -n
