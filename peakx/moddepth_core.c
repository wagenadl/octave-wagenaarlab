/* moddepth_core.c - see moddepth.m */

/* 
gcc -c -W -Wall -I/usr/local/matlab_r14/extern/include -I/usr/local/matlab_r14/simulink/include -DMATLAB_MEX_FILE -fPIC -ansi -D_GNU_SOURCE -pthread -m32  -O -DNDEBUG moddepth_core.c && gcc -c  -I/usr/local/matlab_r14/extern/include -I/usr/local/matlab_r14/simulink/include -DMATLAB_MEX_FILE -fPIC -ansi -D_GNU_SOURCE -pthread -m32  -O -DNDEBUG /usr/local/matlab_r14/extern/src/mexversion.c && gcc -O -pthread -shared -m32 -Wl,--version-script,/usr/local/matlab_r14/extern/lib/glnx86/mexFunction.map -o moddepth_core.mexglx  moddepth_core.o mexversion.o  -Wl,--rpath-link,/usr/local/matlab_r14/bin/glnx86 -L/usr/local/matlab_r14/bin/glnx86 -lmx -lmex -lmat -lm
*/
