#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import time
import os
import sys
import argparse
import subprocess
import datetime
import shlex
import textwrap

def getFiles(directory):
    files_in_dir = []
    for root, dirs, files in os.walk(directory):
        for name in files:
            f = os.path.join(root, name)
            frel = os.path.relpath(f, start=directory)
            files_in_dir.append(frel)
    return files_in_dir

def printList(L):
    for i in L:
        print(i)
    print(f'N={len(L)}')

def cmp(f1, f2, check=True, dryrun=False, use_pv=False):
    s1 = os.path.getsize(f1)
    s2 = os.path.getsize(f2)
    if s1 != s2:
        print(f'{f1} {f2} differ by filesize.')
        return 1
    if not dryrun:
        if not use_pv:
            cmd = ['cmp', '--silent', f1, f2]
            print(shlex.join(cmd))
            cmp_process = subprocess.run(cmd, check=check)
        else:
            cmd0 = ('pv', f1)
            cmd1 = ('cmp', '--silent', f2)
            print(shlex.join(cmd0) + ' | ' + shlex.join(cmd1))
            pv_process = subprocess.Popen(cmd0, stdout=subprocess.PIPE)
            cmp_process = subprocess.run(cmd1, stdin=pv_process.stdout, check=check)
            pv_process.wait()

        if cmp_process.returncode != 0:
            print(f'{f1} {f2} differ by content.')
        return cmp_process.returncode
    else:
        return 0

def sizeof_fmt(num, suffix="B"):
    for unit in ("", "Ki", "Mi", "Gi", "Ti", "Pi", "Ei", "Zi"):
        if abs(num) < 1024.0:
            return f"{num:3.1f}{unit}{suffix}"
        num /= 1024.0
    return f"{num:.1f}Yi{suffix}"

def cmp_recursive(dir1, dir2, check=True, dryrun=False, use_pv=False):

    total_start = time.time()

    print('dir1:', dir1)
    print('dir2:', dir2)
    files_in_dir1 = getFiles(dir1)
    files_in_dir2 = getFiles(dir2)

    if not os.path.isdir(dir1):
        raise Exception(f'dir1 not found or it is not a directory: {dir1}')

    if not os.path.isdir(dir2):
        raise Exception(f'dir2 not found or it is not a directory: {dir2}')

    print('=====> dir1:', dir1)
    printList(files_in_dir1)

    print('=====> dir2:', dir2)
    printList(files_in_dir2)

    print(f'=====> Only in dir1: {dir1}')
    s = set(files_in_dir1) - set(files_in_dir2)
    printList(s)

    print(f'=====> Only in dir2: {dir2}')
    s = set(files_in_dir2) - set(files_in_dir1)
    printList(s)

    print(f'=====> Common files:')
    common_files = set(files_in_dir1) & set(files_in_dir2)
    printList(common_files)

    print(f'=====> Total size of common files:')
    total_size_dir1 = 0
    total_size_dir2 = 0
    for base in common_files:
        f1 = os.path.join(dir1, base)
        f2 = os.path.join(dir2, base)
        total_size_dir1 += os.path.getsize(f1)
        total_size_dir2 += os.path.getsize(f2)
    print(f'dir1: {total_size_dir1} bytes')
    print(f'dir2: {total_size_dir2} bytes')
    if total_size_dir1 != total_size_dir2:
        print('Total size of common files differs.')
        if check:
            return -1

    print(f'=====> Comparing files:')
    total_size_processed = 0
    different_files = []
    Ndiffs = 0
    N = len(common_files)
    for idx, base in enumerate(common_files):
        f1 = os.path.join(dir1, base)
        f2 = os.path.join(dir2, base)
        fsize = os.path.getsize(f1)

        print(f'--> {idx+1}/{N}: {base}, size: {sizeof_fmt(fsize)}')

        ##### Run cmp
        t_start = time.time()
        if cmp(f1, f2, check=check, dryrun=dryrun, use_pv=use_pv) != 0:
            Ndiffs += 1
            different_files.append(base)
        t_end = time.time()
        elapsed = t_end - t_start
        total_elapsed = (t_end - total_start)

        total_size_processed += fsize

        total_size_remaining = total_size_dir1 - total_size_processed

        rate_bytes_per_second = total_size_processed/total_elapsed
        time_remaining = total_size_remaining/rate_bytes_per_second
        estimated_end_time = t_end + time_remaining

        # all size in bytes, unless otherwise specified
        print(f'{base} --> size: {fsize}, '
              f'time: {datetime.timedelta(seconds=elapsed)}, '
              f'total time: {datetime.timedelta(seconds=total_elapsed)}, '
              f'size (processed,remaining)/total: ({total_size_processed},{total_size_remaining})/{total_size_dir1}, '
              f'rate: {60*60*rate_bytes_per_second/(2**30):.3f} GiB/h, '
              f'ETA: {datetime.timedelta(seconds=time_remaining)} -> {datetime.datetime.fromtimestamp(estimated_end_time)}')

    print(f'=====> Files that differ:')
    printList(different_files)

    total_elapsed = (time.time() - total_start)

    print(f'=====> Total time: {datetime.timedelta(seconds=total_elapsed)}')
    print(f'Finished on: {datetime.datetime.fromtimestamp(time.time())}')

    return Ndiffs

def main():
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter,
                                     description=textwrap.dedent('''\
                                     Recursive version of cmp.
                                     
                                     You can just use "diff -rqs dir1 dir2", but this is if you want to make sure a byte-by-byte comparison is performed.
                                     
                                     It looks for all the common files between dir1 and dir2 and then runs cmp between them.
                                     
                                     For example, if the directory layout is:
                                         dir1/a
                                         dir1/b
                                         dir1/d
                                     
                                         dir2/a
                                         dir2/c
                                         dir2/d
                                     
                                     It will run:
                                        cmp dir1/a dir2/a
                                        cmp dir1/d dir2/d
                                     
                                     Exit codes:
                                        if --exit-on-first-diff is used:
                                            0: if no differences
                                            255: if differences found
                                        else:
                                            0: if no differences
                                            N: The number of differences found.
                                     '''))
    # parser.add_argument("-c", "--continue", action='store_true', help='Continue on errors.', dest='cont')
    parser.add_argument("-e", "--exit-on-first-diff", action='store_true', help='Exit on first diff or error.', dest='check')
    parser.add_argument("-n", "--dry-run", action='store_true', help='Perform a dry run, i.e. without actually running cmp.')
    parser.add_argument("-p", "--progress", action='store_true', help='Show progress of each cmp operation. It uses "pv" and might slow down the operation itself.')
    parser.add_argument("dir1")
    parser.add_argument("dir2")
    args = parser.parse_args()

    Ndiffs = cmp_recursive(args.dir1, args.dir2, check=args.check, dryrun=args.dry_run, use_pv=args.progress)
    if Ndiffs == 0:
        sys.exit(0)
    else:
        sys.exit(Ndiffs)

if __name__ == "__main__":
    main()
