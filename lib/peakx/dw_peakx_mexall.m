function dw_peakx_mexall
% DW_PEAKX_MEXALL - Compiles all .c files in "peakx"

a = which('dw_peakx_mexall');
[b,~,~] = splitname(a);
olddir = cd(b);

cc = { 'extendpeaks_core.c',  'maxima_core.c',  'moddepth_core.c' };


for c=1:length(cc)
  fprintf(1, 'Compiling %s\n', cc{c});
  mex(cc{c});
end

cd(olddir);
