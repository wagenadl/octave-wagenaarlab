function dw_statx_mexall
% DW_STATX_MEXALL - Compiles all .c files in "statx"

a = which('dw_statx_mexall');
[b,~,~] = splitname(a);
olddir = cd(b);

cc = { 'unhist_core.c',  'xcorg_int.c' };


for c=1:length(cc)
  fprintf(1, 'Compiling %s\n', cc{c});
  mex(cc{c});
end

cd(olddir);
