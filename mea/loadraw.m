function y = loadraw(fn, range, lim, skip) 
% LOADRAW - Read MEABench raw datafiles
%    y=LOADRAW(fn) reads the raw MEA datafile fn and stores the result in y.
%    y=LOADRAW(fn, range) reads the raw MEA datafile fn and converts the
%    digital values to voltages by multiplying by range/2048. 
%    Range values 0,1,2,3 are interpreted specially:
%    
%    range value   electrode range (uV)    auxillary range (mV)
%         0               3410                 4092
%         1               1205                 1446
%         2                683                  819.6
%         3                341                  409.2
%    
%    "electrode range" is applied to channels 0..59, auxillary range is
%    applied to channels 60..63. Note that channel HW is stored in the
%    (HW+1)-th row of the output.
%    y = LOADRAW(fn, range, lim) reads only the first LIM scans.
%    y = LOADRAW(fn, range, lim, skip) skips the first SKIP scans and then
%    reads LIM scans.
%    LOADRAW will also load followups (files named FN-1, FN-2, etc. ).

% matlab/loadraw.m: part of meabench, an MEA recording and analysis tool
% Copyright (C) 2000-2002  Daniel Wagenaar (wagenaar@caltech.edu)
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

if nargin<3 || isempty(lim)
  lim=inf;
end
if nargin<4
  skip=0;
end

if nargin<=2
  range = [];
end

if ~isempty(range)
  if ~isempty(find([0 1 2 3]==range))
    ranges= [ 3410,1205,683,341 ];
    range = ranges(range+1);
    auxrange = range*1.2;
  else
    auxrange = range;
  end
end

fno=0;
fh = fopen(fn,'rb');
if fh<0
  error(['Cannot read file ' fn]);
end
fseek(fh,0,'eof');
flen=ftell(fh);
while 2*64*skip>flen
  fclose(fh);
  skip = skip-flen/(2*64);
  fno = fno + 1;
  myfn = sprintf('%s-%i',fn, fno);
  fh = fopen(myfn, 'rb');
  if fh<0
    error(['Cannot read file ' myfn]);
  end
  fseek(fh,0,'eof');
  flen=ftell(fh);
end
fseek(fh,2*64*skip,'bof');
y = fread(fh,[64 lim],'int16');
fclose(fh);
sofar = size(y,2);
while sofar<lim
  fno = fno + 1;
  myfn = sprintf('%s-%i',fn, fno);
  fh = fopen(myfn, 'rb');
  if fh<0
    if lim<inf
      error(['Cannot read file ' myfn]);
    end
  else
    break
  end
  y = [y fread(fh,[64 lim-sofar],'int16')];
  fclose(fh);
  sofar = size(y,2);
end

if ~isempty(range)
  fprintf(2,'Converting for range %g uV [and %g mV]\n',range,auxrange);
  y(1:60,:) = y(1:60,:) * range/2048;
  y(61:64,:)= y(61:64,:) * auxrange/2048;
end
