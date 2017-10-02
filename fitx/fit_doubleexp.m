function [A, B, C, D, E, chi2, p] = fit_doubleexp(x,y,A0,B0,C0,D0,E0,pltx)
% [A B C D E] = FIT_DOUBLEEXP(x,y,[A0 B0 C0 D0 E0]) fits an exponential 
% to the data:
%
%        Bx      Dx
% Y = A e   + C e   + E
%
% Additional argument PLOTX forces a plot of the fit at points in PLOTX.
% Additional output argument CHI2 returns chi^2 value.
% Third output argument returns plot handle.

[par,chi2] = fminsearch(@foo_doubleexp,[A0 B0 C0 D0 E0],[],[x y]);
A=par(1); 
B=par(2);
C=par(3);
D=par(4);
E=par(5);

if nargin>=8
  p=plot(pltx,A*exp(B*pltx)+C*exp(D*pltx)+E);
end

function chi2=foo_doubleexp(par,xy)
f=par(1)*exp(xy(:,1).*par(2))+par(3)*exp(xy(:,1).*par(4))+par(5);
chi2 = sum((xy(:,2)-f).^2)/(size(xy,1)-5);
