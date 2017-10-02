function in = inrange(x,xmin,xmax)
% INRANGE   True if a value is in a given range
%    INRANGE(x,xmin,xmax) returns True if X is strictly in the range
%    (XMIN,XMAX), i.e. if  xmin < x < xmax.
%    This works for scalar or matrix X. 
in = x>xmin & x<xmax;
