function [xx, yy] = xxyy(N, M)
% XXYY - Return a pair of XX and YY matrices
%   [xx, yy] = XXYY(N, M) returns a pair of NxM matrices where XX increases
%   from 0 to 1 from left to right and YY increases from 0 to 1 from top to
%   bottom.
%   [xx, yy] = XXYY(N) returns square NxN matrices.
%   [xx, yy] = XXYY returns 100x100 matrices.

if nargin<1
  N = 100;
end
if nargin<2
  M = N;
end

xx = [0:M-1] / (M-1);
yy = [0:N-1]' / (N-1);
xx = repmat(xx, N, 1);
yy = repmat(yy, 1, M);

