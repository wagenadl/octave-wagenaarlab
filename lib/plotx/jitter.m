function yy=jitter(xx,dx)
% JITTER - Returns data with added uniform jitter
%    yy = JITTER(xx) returns yy = xx + (rand-0.5).
%    yy = JITTER(xx,dx) returns yy = xx + (rand-0.5)*dx.
%    See also: JITTER0

if nargin<2
  dx = 1;
end

yy = xx + (rand(size(xx))-.5)*dx;