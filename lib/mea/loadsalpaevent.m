function y=loadsalpaevent(fn,cvt)
% y=LOADSALPAEVENT(fn) loads salpa events from the given file, and returns
% a structure with members
%   time    (1xN) (in samples)
%   channel (1xN)
%   duration (1xN) (in samples)
% If a second argument is passed, time is converted to seconds, duration to ms,
% assuming 25 kHz sampling rate.

% matlab/loadsalpaevent.m: part of meabench, an MEA recording and analysis tool
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


fid = fopen(fn,'rb');
if (fid<0)
  error('Cannot open the specified file');
end
raw = fread(fid,[8 inf],'uint16');
fclose(fid);
ti0 = raw(1,:); 
ti1 = raw(2,:); 
ti2 = raw(3,:); 
ti3 = raw(4,:); 
y.time = (ti0 + 65536*(ti1 + 65536*(ti2 + 65536*ti3)));
dur0 = raw(5,:);
dur1 = raw(6,:);
y.duration = dur0 + 65536*dur1;
y.channel = raw(7,:);

if nargin>1 & ~isempty(cvt)
  y.duration = y.duration / 25;
  y.time = y.time / 25000;
end
