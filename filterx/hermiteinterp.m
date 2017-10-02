function [yy,tt] = hermiteinterp(xx,n,bias,tension)
% yy = HERMITEINTERP(xx,n,bias,tension) performs equally spaced Hermite
% interpolation of the data XX to N times the original frequency.
% [yy,tt] = HERMITEINTERP(...) returns the new time point vector as well.
%
% Algorithm lifted from http://astronomy.swin.edu.au/~pbourke/other/interpolation/,
% by Paul Bourke, December 1999.

[A B]=size(xx);
xx=xx(:)';
xx=[xx(1) xx xx(end)];
L=length(xx);
tt=[2:1/n:L-2];
base=floor(tt) - 1;
mu=tt-floor(tt);
mu2 = mu.*mu;
mu3 = mu.*mu2;
m0 = (xx(base+1)-xx(base+0)) * (1+bias)*(1-tension)/2 + ...
    (xx(base+2)-xx(base+1)) * (1-bias)*(1-tension)/2;
m1 = (xx(base+2)-xx(base+1)) * (1+bias)*(1-tension)/2 + ...
    (xx(base+3)-xx(base+2)) * (1-bias)*(1-tension)/2;
a0 =  2*mu3 - 3*mu2 + 1;
a1 =    mu3 - 2*mu2 + mu;
a2 =    mu3 -   mu2;
a3 = -2*mu3 + 3*mu2;

yy = a0.*xx(base+1) + a1.*m0 + a2.*m1 + a3.*xx(base+2);

