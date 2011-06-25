function q=randscat88(spks)
% RANDSCAT88(spks) plots scatter plots of the (spontaneous activity) spikes
% in SPKS. It stacks thin horizontal raster plots for each channel. Within
% each plot, spikes are randomly positioned vertically for clarity.
% SPKS must have been loaded using LOADSPIKE or LOADSPIKE_NOC.
% Column-row numbers are computed from channel numbers using hw2cr.
%
% p = RANDSCAT88(spks) returns the plot handle.

% matlab/randscat88.m: part of meabench, an MEA recording and analysis tool
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

p=plot(spks.time,hw2cr(spks.channel) + 0.7*rand(size(spks.channel)) -.35,'.');

set(p,'markersize',2);
xlabel 'Time (s)'
ylabel 'Channel (CR)'
axis tight
set(gca,'ytick',[12 17 21 28 31 38 41 48 51 58 61 68 71 78 82 87]);

if nargout>0
  q=p;
end
