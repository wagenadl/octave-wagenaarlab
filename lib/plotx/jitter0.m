function yy=jitter0(xx,dx)
% JITTER0 - Returns data replaced with jitter
%    yy = JITTER0(xx,dx) returns yy = (rand(size(xx))-.5)*dx
%    See also: JITTER

yy = (rand(size(xx))-.5)*dx;