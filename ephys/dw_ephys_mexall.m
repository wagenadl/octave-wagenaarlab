function dw_ephys_mexall
% DW_EPHYS_MEXALL - Compiles all .c files in "ephys"

a = which('dw_ephys_mexall');
[b,~,~] = splitname(a);
olddir = cd(b);

cc = { 'latency_core.cpp' };

for c=1:length(cc)
  fprintf(1, 'Compiling %s\n', cc{c});
  mex(cc{c});
end

cd(olddir);
