function dat=loadonechannel(fn) 
% dat=LOADONECHANNEL(fn) loads the one channel raw data from fn into dat.

fh=fopen(fn,'rb');
dat=fread(fh,[1 inf],'int16');
dat=(dat-2048)*341/2048;
fclose(fh);

  