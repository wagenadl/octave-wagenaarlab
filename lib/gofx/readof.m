function [dx,dy] = readof(ifn)
% READOF - Read result of optic flow analysis
%    [dx, dy] = READOF(ifn) reads the file IFN, which much be a vL.FN.mM 
%    output from "gof", and returns matrix of displacements.
%    This works for integer (.short), real (.float), and text files.

if strcmp(ifn(end-5:end),'.float')
  fd=fopen(ifn,'rb');
  dat=fread(fd,[1 inf],'float');
  dat=double(dat);
  fclose(fd);
elseif strcmp(ifn(end-5:end),'.short')
  fd=fopen(ifn,'rb');
  dat=fread(fd,[1 inf],'int16');
  dat=double(dat);
  dat(3:end)=dat(3:end)/1000;
  fclose(fd);
else
  dat=load(ifn,'text');
end

Y=dat(1);
X=dat(2);
dy=dat(2+[1:(Y*X)]);
dx=dat(2+Y*X+[1:(Y*X)]);
dy=reshape(dy,[X Y])';
dx=reshape(dx,[X Y])';
