#!/bin/sh
# source: https://superuser.com/questions/602818/how-to-get-the-actual-directory-size-out-of-du
find ${1:-.} -type f -exec ls -lnq {} \+ | awk '
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
