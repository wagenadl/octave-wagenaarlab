function dw_salpa_mexall
% DW_SALPA_MEXALL - Compiles all .c files in "salpa"

a = which('dw_salpa_mexall');
[b,~,~] = splitname(a);
olddir = cd([b filesep 'private']);

fprintf(1, 'Compiling salpamex.cpp LocalFit.cpp\n');

mex salpamex.cpp LocalFit.cpp

cd(olddir);
