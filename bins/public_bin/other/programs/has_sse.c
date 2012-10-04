#include <stdlib.h>
  
int main(void)
{
  printf("has_sse=%d\n",has_sse());
}

int has_sse(void)
{
  return(system("has_sse.sh"));
}
