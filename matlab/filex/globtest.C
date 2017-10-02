// globtest.C

#if 0
g++ -o globtest globtest.C -W -Wall
#endif

#include <glob.h>
#include <stdio.h>

int main() {
  char *pat="/home/wagenaar/matlab/*x/a*.m";
  glob_t pglob;
  if (glob(pat,GLOB_TILDE,0,&pglob)) {
    perror("glob failed");
    return 1;
  }
  for (int k=0; k<pglob.gl_pathc; k++) 
    printf("-> %s\n",pglob.gl_pathv[k]);
  globfree(&pglob);
  return 0;
}
