#!/bin/bash
set -u
find $1 -name \*.flv -print0 \
| xargs -0 magicrescue -Mio -r flv -d /video_processing/recovery/ 2>/dev/null \
|/usr/lib/magicrescue/tools/checkrecipe
