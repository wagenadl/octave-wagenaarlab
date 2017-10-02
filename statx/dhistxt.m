function [nn, tt, cc] = dhistxt(xx, n, varargin)
% DHISTXT - 2D histogram of timeseries data
%   DHISTXT(xx, n) plots a 2D histogram of the rows in XX with N bins in the
%   vertical direction and T bins in the horizontal direction if XX is shaped
%   TxK.
%   DHISTXT(xx, cc) specifies bin centers instead of bin count.
%
%   nn = DHISTXT(...) returns bin counts instead of plotting. Output will be
%   shaped TxN where N is the number of vertical bins.
%   [nn, tt, cc] = DHISTXT(...) returns bin counts and bin centers. This can
%   be fed to imagesc as in: IMAGESC(tt, cc, nn');
%
%   DHISTXT(xx, n, k1, v1, ...) specifies additional options, which may 
%   include:
%      oversample: factor by which to oversample in time domain for smoother
%                  and denser plotting. Cautions from the documentation
%                  of UPSAMPLE apply.
%      finer: factor by which to produce data points between integer time bins.
%
%   See also: SMOKE

[T, K] = size(xx);
kv = getopt('oversample=1 finer=1', varargin);

tt=[1:T]';
F = kv.oversample*kv.finer;
if F>1
  [xx, tt] = upsample(xx, F);
  T = length(tt);
end

if isnscalar(n)
  [dd, cc] = hist(xx(:), n);
else
  cc = n;
end
C = length(cc);

nn = zeros(T, C);
for t=1:T
  nn(t,:) = hist(xx(t,:), cc);
end
nn = nn/kv.finer;

F = kv.oversample;
if F>1
  T = floor(T/F);
  nn = squeeze(mean(reshape(nn(1:F*T, :), [F T C])));
  tt = mean(reshape(tt(1:F*T), [F T]))';
end

if nargout==0
  imagesc(tt, cc, nn');
  clear
  return
end

  