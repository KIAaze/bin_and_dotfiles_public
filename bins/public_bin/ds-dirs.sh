#!/bin/sh
# same as ds.sh, but for directories only.

# source: https://superuser.com/questions/602818/how-to-get-the-actual-directory-size-out-of-du

# ls options:
#     -l     use a long listing format
#     -n, --numeric-uid-gid
#               like -l, but list numeric user and group IDs
#     -q, --hide-control-chars
#           print ? instead of nongraphic characters
#      -d, --directory
#           list directories themselves, not their contents

find "${1:-.}" -type d -exec ls -lnqd {} \+ | awk '
BEGIN {sum=0} # initialization for clarity and safety
function pp() {
  u="+Ki+Mi+Gi+Ti";
  split(u,unit,"+");
  v=sum;
  for(i=1;i<6;i++) {
    if(v<1024) break;
    v/=1024;
  }
  printf("%d bytes = %.3f %sB\n", sum, v, unit[i]);
}
{sum+=$5}
END{pp()}'
