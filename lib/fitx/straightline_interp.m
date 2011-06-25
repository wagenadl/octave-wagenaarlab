function [y,sy] = straightline_interp(x,a,b,sa,sb,sab)
% [y,sy] = STRAIGHTLINE_INTERP(x,a,b,sa,sb,sab)
% Given data points X, and straight line fit parameters A, B, SA, SB, SAB,
% calculates the function values Y and their uncertainties SY.

y = a*x + b;
sy = sqrt(sa^2*x.^2 + sb^2 + 2*sab*x);
