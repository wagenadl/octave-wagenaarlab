function [t0,s2]=halfslope(rate,mfr,R,fw,th)
% [t0,s2]=HALFSLOPE(rate,mfr,R,fw,th) calculates the burst initiation
% times per channel of the burst data in RATE (TxD), based on
% smoothing the histogram and finding the first timepoint where the
% rate exceeds half the peak rate.
% Input:
%   rate (TxD) 	specifies the observed firing rate in time bins 1:T
%              	on channels 1:D
%   mfr (1xD)  	specifies the Mean Firing Rate on each channel, used
%              	for generating Poisson statistics (see below).
%              	Default is zero. (Units: hits per bin, not per second!)
%   R (scalar) 	specifies how many Monte Carlo resamplings should be
%              	performed for the estimation of the variance.
%              	Default is 10 if s2 is requested, else 0.
%   fw (scalar) specifies a smoothing filter width. Default is 3
%               bins.
%   th (scalar) specifies a minimum total number of spikes per
%               channel for that channel to return any s2.
% Output:
%   t0 (1xD) start time estimated from observations
%   s2 (1xD) variance in start times estimated from Monte Carlo
%            simulation.
%
% About the calc of s2: For each channel independently, an
% alternative rate distribution is sampled from Poisson statistics
% with lambda obtained from rate. This is done R times, and the
% resulting t values are used to estimate s2. Any bins that have
% zero observed count are replaced by lambda=mfr(d).

[T,D] = size(rate);

if nargin<4
  fw=3; % Smoothing filter width
end
if nargin<3
  R=10;
end
if nargin<2
  mfr=zeroes(1,D);
end
if length(mfr)==1
  mfr=zeros(1,D) + mfr;
end
if nargout<2
  R=0;
end

fb=exp(-[-4:(1/fw):4].^2);
fb=fb/sum(fb);
fa=zeros(length(fb),1); fa(1)=1;
sub=ceil(length(fb)/2);

smooth=filter(fb,fa,rate);
thr=max(smooth)/2;

t0=zeros(1,D);
for d=1:D
  t0(d)=min(find(smooth(:,d)>=thr(d))) - sub;
end
  
if R>0
  s2=zeros(1,D)+inf;
  dd=[1:D];%find(thr>.5);
  for d=dd(:)'
    sample = zeros(T,R);
    idx=find(rate(:,d)==0);
    rate(idx,d) = mfr(d);
    for t=1:T
      sample(t,:) = poisson_rand(rate(t,d),R);
    end
    smooth=filter(fb,fa,sample);
    thr=max(smooth)/2;
    tt=zeros(R,1);
    for r=1:R
      tt(r)=min(find(smooth(:,r)>=thr(r))) - sub;
    end
    s2(d)=sum((tt-t0(d)).^2)/(R-1);
  end
end

return

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % ------------------------------------------------------------------ %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rnd = poisson_rand(l, s)
% This function is adapted from octave code. I haven't checked
% whether the matlab statistics toolbox has something faster.

% Original comments follow:

%## Copyright (C) 1995, 1996, 1997  Kurt Hornik
%## 
%## This program is free software; you can redistribute it and/or modify
%## it under the terms of the GNU General Public License as published by
%## the Free Software Foundation; either version 2, or (at your option)
%## any later version.
%## 
%## This program is distributed in the hope that it will be useful, but
%## WITHOUT ANY WARRANTY; without even the implied warranty of
%## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%## General Public License for more details. 
%## 
%## You should have received a copy of the GNU General Public License
%## along with this file.  If not, write to the Free Software Foundation,
%## 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
%
%## usage:  poisson_rnd (lambda [, r, c])
%##
%## poisson_rnd (lambda) returns a matrix of random samples from the
%## Poisson distribution with parameter lambda.  The size of the matrix
%## is the size of lambda.
%##
%## poisson_rnd (lambda, r, c) returns an r by c matrix of random samples
%## from the Poisson distribution with parameter lambda, which must be a
%## scalar or of size r by c.
%  
%## Author:  KH <Kurt.Hornik@ci.tuwien.ac.at>
%## Description:  Random deviates from the Poisson distribution

% End of original comments

rnd = zeros(1,s);

if l==0
  return
end

all = -log(1-rand(1,s))./l;
while (1)
  ind=find(all<1);
  if isempty(ind)
    break
  end
  all(ind)=(all(ind)-log(1-rand(1,length(ind)))./l);
  rnd(ind)=rnd(ind)+1;
end
return
