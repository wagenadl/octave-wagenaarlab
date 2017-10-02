function y = loadmcsraw1c(fn, hw, range, lim, skip) 
% LOADMCSRAW1C - Read MCRack raw datafiles
%    y=LOADMCSRAW1C(fn, hw) reads the raw MCS datafile fn and stores the result
%    for electrode HW (counted 0..59) in y.
%    y=LOADMCSRAW1C(fn, hw, range) reads the raw MEA datafile fn and converts
%    the digital values to voltages by multiplying by range/2048. 
%    Range values 0,1,2,3 are interpreted specially:
%    
%    range value   electrode range (uV)
%         0               3410        
%         1               1205       
%         2                683      
%         3                341     
%    
%    y = LOADMCSRAW1C(fn, hw, range, lim) reads only the first LIM scans.
%    y = LOADMCSRAW1C(fn, hw, range, lim, skip) skips the first SKIP scans 
%    and then reads LIM scans.
%    LOADMCSRAW1C will also load followups (files named FN-1, FN-2, etc. ).

% matlab/loadraw1c.m: part of meabench, an MEA recording and analysis tool
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

if nargin<4 || isempty(lim)
  lim=inf;
end
if nargin<5
  skip=0;
end

if nargin<=3
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
while 2*60*skip>flen
  fclose(fh);
  skip = skip-flen/(2*60);
  fno = fno + 1;
  myfn = sprintf('%s-%i',fn, fno);
  fh = fopen(myfn, 'rb');
  if fh<0
    error(['Cannot read file ' myfn]);
  end
  fseek(fh,0,'eof');
  flen=ftell(fh);
end
fseek(fh,2*60*skip,'bof');
y = zeros(1,0);
while 1
  fprintf(1, 'So far: %.1fM\r', length(y)/1e6);
  z = fread(fh,[60 min(lim-length(y), 64*1024)],'int16');
  if isempty(z)
    break;
  else
    y = [y z(hw+1,:)];
  end
end
fclose(fh);
while length(y)<lim
  fno = fno + 1;
  myfn = sprintf('%s-%i',fn, fno);
  fh = fopen(myfn, 'rb');
  if fh<0
    if lim<inf
      error(['Cannot read file ' myfn]);
    else
      break
    end
  end
  fh
  while 1
    fprintf(1, 'So far: %.1fM\r', length(y)/1e6);
    z = fread(fh,[60 min(lim-length(y), 64*1024)], 'int16');
    if isempty(z)
      break;
    else
      y = [y z(hw+1,:)];
    end
  end
  fclose(fh);
end
fprintf(1, 'Read %.1f Mscans       \n', length(y)/1e6);

if ~isempty(range)
  fprintf(2,'Converting for range %g uV [and %g mV]\n',range,auxrange);
  if hw<60
    y = y * range/2048;
  else
    y = y * auxrange/2048;
  end
end
