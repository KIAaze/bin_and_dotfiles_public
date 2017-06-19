#!/bin/sh
# source: https://superuser.com/questions/602818/how-to-get-the-actual-directory-size-out-of-du
find ${1:-.} -type f -exec ls -lnq {} \+ | awk '
#base=1024;
function pp(base) {
  #base=1000;
  printf("=====> base=%d\n", base);
  u="+Ki+Mi+Gi+Ti";
  split(u,unit,"+");
  v=sum;
  r=0;
  printf("v=%f\n", v);
  printf("%f\n", 5/2);
  for(i=1;i<6;i++) {
    printf("%d -> %s <-\n", i, unit[i]);
  }
  for(i=1;i<5;i++) {
    printf("i=%d\n", i);
    if(v<base) break;
    r=v%base;
    v/=base;
    printf("v=%f, r=%f\n",v,r);
  }
#  printf("%.3f %sB\n",v+r/base,unit[i]);
  printf("%.3f %sB\n",v,unit[i]);
}
{sum+=$5}
END{
pp(1000)
pp(1024)
}'
