function [a,b,sa,sb,sab,chi2] = straightlinefit(x,y,sy)
% [a,b,sa,sb,sab,chi2] = STRAIGHTLINEFIT(x,y,sy)
% Given data points (X,Y) with uncertainties SY on Y, perform a straight
% line fit
%
%   y = a x + b
%
% Besides returning A and B, you also get uncertainties SA on A and SB on B,
% and covariance SAB between the parameters, as well as a chi^2 value.
% Note that SA and SB are sigma, not sigma^2 values.

hat1 = sum(1./sy.^2);
hatx = sum(x./sy.^2);
haty = sum(y./sy.^2);
hatxy = sum(x.*y./sy.^2);
hatxx = sum(x.*x./sy.^2);

a = (hat1*hatxy - hatx*haty) / (hat1*hatxx - hatx^2);
b = (hatxx*haty - hatx*hatxy) / (hat1*hatxx - hatx^2);
sa = sqrt(hat1 / (hat1*hatxx - hatx^2));
sb = sqrt(hatxx / (hat1*hatxx - hatx^2));
sab = -hatx / (hat1*hatxx - hatx^2);
chi2 = sum((y-(a*x+b)).^2./sy.^2);
