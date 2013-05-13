function y=loadspike(fn,range,freq,n)
% y=LOADSPIKE(fn) loads spikes from given filename into structure y
% with members
%   time    (1xN) (in samples)
%   channel (1xN)
%   height  (1xN)
%   width   (1xN)
%   context (75xN)
%   thresh  (1xN)
% y=LOADSPIKE(fn,range,freq_khz) converts times to seconds and width to
% milliseconds using the specified frequency, and the height and
% context data to microvolts by multiplying by RANGE/2048.
% As a special case, range=0..3 is interpreted as a MultiChannel Systems 
% gain setting:
% 
% range value   electrode range (uV)    auxillary range (mV)
%      0               3410                 4092
%      1               1205                 1446
%      2                683                  819.6
%      3                341                  409.2
% 
% "electrode range" is applied to channels 0..59, auxillary range is
% applied to channels 60..63.
% In this case, the frequency is set to 25 kHz unless specified.
%
% y=LOADSPIKE(...,n) only loads the first N spikes.

% matlab/loadspike.m: part of meabench, an MEA recording and analysis tool
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


if nargin<2 || isempty(range)
  range=nan;
end
if nargin<3 || isempty(freq)
  freq=nan;
end
if nargin<4 || isempty(n)
  n=inf;
end

fid = fopen(fn,'rb');
if (fid<0)
  error('Cannot open the specified file');
end
raw = fread(fid,[82 n],'int16');
fclose(fid);
ti0 = raw(1,:); idx = find(ti0<0); ti0(idx) = ti0(idx)+65536;
ti1 = raw(2,:); idx = find(ti1<0); ti1(idx) = ti1(idx)+65536;
ti2 = raw(3,:); idx = find(ti2<0); ti2(idx) = ti2(idx)+65536;
ti3 = raw(4,:); idx = find(ti3<0); ti3(idx) = ti3(idx)+65536;
y.time = (ti0 + 65536*(ti1 + 65536*(ti2 + 65536*ti3)));
y.channel = raw(5,:);
y.height = raw(6,:);
y.width = raw(7,:);
y.context = raw(8:81,:);
y.thresh = raw(82,:);

if ~isnan(range)
  if ~isempty(find([0 1 2 3]==range))
    ranges= [ 3410,1205,683,341 ];
    range = ranges(range+1);
    auxrange = range*1.2;
    if isnan(freq)
      freq = 25.0;
    end
    isaux = find(y.channel>=60);
    iselc = find(y.channel<60);
    y.height(iselc) = y.height(iselc) .* range/2048;
    y.thresh(iselc) = y.thresh(iselc) .* range/2048;
    y.context(:,iselc) = y.context(:,iselc) .* range/2048;
    y.height(isaux) = y.height(isaux) .* auxrange/2048;
    y.thresh(isaux) = y.thresh(isaux) .* auxrange/2048;
    y.context(:,isaux) = y.context(:,isaux) .* auxrange/2048;
  else
    y.height = y.height  .* range/2048;
    y.thresh = y.thresh  .* range/2048;
    y.context= y.context .* range/2048;
  end
end    

if ~isnan(freq)
  y.time = y.time ./ (freq*1000);
  y.width = y.width ./ freq;
end
