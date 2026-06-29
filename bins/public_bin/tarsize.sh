#!/bin/bash
# print size of contents of tar.gz file in bytes
# https://superuser.com/questions/521596/find-out-the-size-of-a-tar-gz-archive-in-the-terminal-without-unpacking
tar -tvzf "${1}" | awk '{ s += $3 } END { print s }'
