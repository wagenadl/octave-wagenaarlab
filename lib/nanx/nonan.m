function y = nonan(x)
% y = NONAN(x) returns all non-nan values in the vector x.
y = x(~isnan(x));
