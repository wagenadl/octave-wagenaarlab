function yy=jitter(xx,dx)
% JITTER - Returns data with added jitter
%    yy = JITTER(xx,dx) returns yy = xx + (rand(size(xx))-.5)*dx
%    See also: JITTER0

yy = xx + (rand(size(xx))-.5)*dx;