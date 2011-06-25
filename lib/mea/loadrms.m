function rms=loadrms(fn)
% rms=LOADRMS(fn) loads the rms file specified. See meabench:rms for details
fh=fopen(fn,'rb');
rms=fread(fh,[64 inf],'float');
fclose(fh);