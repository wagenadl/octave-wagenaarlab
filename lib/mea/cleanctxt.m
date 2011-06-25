function[ctxts,idx]=cleanctxt(contexts, testidx, relthresh)
% [ctxts, idx] = CLEANCTXT(contexts) returns cleaned up contexts:
% - The first and last 15 values are averaged and used to compute DC offset.
% - These two estimates are weighted according to their inverse variance.
% - The DC offset is subtracted.
% - If any sample in -1:-0.5 or 0.5:1.5 ms is more than half the peak at 0 ms,
%   the spike is rejected.
% - Use CLEANCTXT(contexts, testidx, relthresh) to modify this test:
%     TESTIDX are indices (1:74) of samples to test, 
%     RELTHRESH is a number between 0 and 1.
% - Additionally, the area immediately surrounding the peak is tested at
%   the 0.9 level: The spike is also rejected if any sample in -1:-0.16
%   or 0.16:1.5 ms has an absolute value more than 0.9 x the absolute peak
%   value. This test is modified on its outer edges by the edges of
%   testidx, but cannot be modified independently.
% Returns: ctxts: the accepted contexts, with DC subtracted
%          idx: the index of accepted spikes.
% Requirements: contexts must be as read from loadspike, i.e. 74xN (or
%          75xN).
% Acknowledgment: The algorithm implemented by this function is due 
%          to Partha P Mitra.

% matlab/cleanctxt.m: part of meabench, an MEA recording and analysis tool
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


if nargin<3
  relthresh=0.5;
end
if nargin<2
  testidx=[[5:13] [40:50]];
end

abstestidx=[1:74];
abstestidx([1:min(testidx)-1])=0;
abstestidx([max(testidx)+1:74])=0;
%abstestidx(testidx)=0;
abstestidx([23:28])=0;
abstestidx=abstestidx(find(abstestidx));

N=size(contexts,2);
idx=zeros(1,N);
ctxts=zeros(74,N);

out=0;
for in=1:N
  first=contexts(1:15,in);
  last=contexts(61:74,in);
  dc1=mean(first);
  dc2=mean(last);
  v1=var(first);
  v2=var(last);
  dc=(dc1*v2+dc2*v1)/(v1+v2+1e-10); % == (dc1/v1 + dc2/v1) / (1/v1 + 1/v2)
  now=contexts(1:74,in) - dc;
  peak=mean(now(25:26));
  if peak<0
    bad=length(find(now(testidx) <= relthresh*peak));
  else
    bad=length(find(now(testidx) >= relthresh*peak));
  end
  if bad==0
    bad=length(find(abs(now(abstestidx)) >= 0.9*abs(peak)));
  end
  if bad==0
    out=out+1;
    ctxts(:,out) = now;
    idx(:,out) = in;
  end
end

ctxts=ctxts(:,1:out);
idx=idx(1:out);
