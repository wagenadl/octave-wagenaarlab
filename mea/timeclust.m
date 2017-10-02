function [t0,cnt,dt]=timeclust(spktms_s,bin_s,thr_mean,thr_abs,smooth)
% [t0,cnt,dt] = TIMECLUST(tms_s,bin_s,thr_mean,thr_abs)
% Given a set of times TMS_S and a bin size BIN_S (both nominally in seconds),
% find the locations, volumes, and widths of peaks in the time distribution.
% A peak is (primitively) defined as a contiguous area of bins exceeding
% THR_ABS *and* exceeding THR_MEAN times the mean bin count. Either THR_MEAN
% or THR_ABS may be left unspecified, in which case THR_ABS defaults to >=2.
%
% A 6th argument, SMOOTH, may be given to smooth the histogram using
% GAUSSIANBLUR1D before thresholding. This is less useful.
%
% Note that this is a very primitive peak detector, but it seems to be 
% good enough. Algorithm and code by DW, 6/25/02.

% matlab/timeclust.m: part of meabench, an MEA recording and analysis tool
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

N=ceil(max(spktms_s/bin_s));
if isempty(N)
  t0=[];
  cnt=[];
  dt=[];
  return;
end

y = [0 hist(spktms_s/bin_s,[0:N+1]) 0];

if nargin>=5
  y = gaussianblur1d(y',smooth)';
end

if nargin<4
  thr_abs = 1.5;
end
if isempty(thr_mean)
  thr_mean=0;
end
if isempty(thr_abs)
  thr_abs = 1.5;
end

thr = thr_mean * mean(y);
thr = max([thr thr_abs]);
high = y > thr;
updown = diff(high);
up = find(updown>0);
dn = find(updown<0);

K=length(up);
t0=zeros(1,K);
cnt=zeros(1,K);
dt=zeros(1,K);

for k=1:K
  tup = (up(k)-1.5) * bin_s;
  tdn = (dn(k)-1.5) * bin_s;
  ok = find(spktms_s>tup & spktms_s<tdn);
  
  cnt(k) = length(ok);
  if cnt(k)>=1
    t0(k) = mean(spktms_s(ok));
  else
    t0(k) = nan;
  end
  
  if cnt(k)>=2
    dt(k) = std(spktms_s(ok));
  else
    dt(k) = nan;
  end

%  idx = [up(k)+1:down(k)];
%  cnt(k) = sum(y(idx));
%  t0(k) = bin_s * sum(y(idx).*(idx-2)) ./ cnt(k);
%  dt(k) = sqrt(bin_s^2 * sum(y(idx).*(idx-2).^2)./cnt(k) - t0(k).^2);
end

  