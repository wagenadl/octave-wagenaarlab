function [tt,chcnt,dtt] = burstdet_timeclust(spks, bin_s, thr_mean)
% [tt,chcnt,dtt] = BURSTDET_TIMECLUST(spks, bin_s, thr_mean)
% Given a set of spikes SPKS loaded by LOADSPIKE or LOADSPIKE_NOC, finds
% synchronized bursts (on 5 or more channels).
% This works by first finding bursts on individual channels using TIMECLUST,
% and then finding synchronized bursts by clustering the single-channel
% bursts, again using TIMECLUST.
% Both BIN_S and THR_MEAN are optional; default values are 0.1 s and 5x
% resp.
%
% This two step approach is due to Andrew Wong. Code by DW, 6/25/02.
% Note: Only the fields TIME and CHANNEL are used from SPKS.


% matlab/burstdet_timeclust.m: part of meabench, an MEA recording 
% and analysis tool
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


if nargin<2 | isempty(bin_s)
  bin_s = 0.1;
end
if nargin<3 | isempty(thr_mean)
  thr_mean = 5;
end
cnts=zeros(1,0);
t0s=zeros(1,0); 
dts=zeros(1,0); 
chs=zeros(1,0); 
for c=1:60
  [t0,cnt,dt]=timeclust(spks.time(spks.channel==c-1),bin_s,5);
  t0s=[t0s t0]; 
  dts=[dts dt]; 
  chs=[chs repmat(c,1,length(t0))] ;
end



[tt,chcnt,dtt] = timeclust(t0s,.25,[],5);
