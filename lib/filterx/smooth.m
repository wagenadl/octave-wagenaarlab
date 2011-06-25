function y = smooth(x,iters,factor)
% y = SMOOTH(x,iters,factor) returns a smoothed version of the matrix x by 
% repeatedly adding up and down shifted versions to it.
% For triangular smoothing use factor=1 (the default);
% For non-triangular smoothing, use 0<factor<1.
if (nargin<3)
  factor = 1;
end

y = x;
scale = 1 / (1+2*factor);
for i = (1:iters)
  y = scale*(y + factor*(shift(y,1) + shift(y,-1)));
end
