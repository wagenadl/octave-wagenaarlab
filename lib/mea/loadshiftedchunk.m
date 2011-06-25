function [yy,tt] = loadshiftedchunk(ifn, t0, dt, chshft)
% LOADSHIFTEDCHUNK - Loads a chunk of MEA data with possible channel shift
%   [yy,tt] = LOADSHIFTEDCHUNK(ifn, t0, dt, chshft) loads DT seconds of data 
%   from file IFN starting at time T0 (in seconds). If CHSHFT is specified,
%   a shift of CHSHFT channels is corrected for.

if nargin<4
  chshft = 0;
end

i0 = floor(25000*t0);
di = floor(25000*dt);

fd = fopen(ifn,'r');
if fd<0
  error(['Cannot open ' ifn]);
end
fseek(fd,0,'eof');
i1 = ftell(fd)/64/2;
fno = 0;
while i0>=i1
  fclose(fd);
  fno = fno+1
  fd = fopen(sprintf('%s-%i',ifn,fno),'r');
  i0 = i0 - i1;
  fseek(fd,0,'eof');
  i1 = ftell(fd);
end

fseek(fd,2*(i0*64+chshft),'bof');
yy = fread(fd,[64*di 1],'int16');
fclose(fd);
if length(yy)<64*di
  fno=fno+1;
  fd = fopen(sprintf('%s-%i',ifn,fno),'r');
  yy=[yy; fread(fd,[64*di-length(yy) 1],'int16')];
  fclose(fd);
end

yy=reshape(yy,[64 di])';
tt=[1:size(yy,1)]'-1;
tt=tt/25000 + t0;
