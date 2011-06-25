function [A, B, C, chi2, p]=fit_exp(x,y,A0, B0, C0, pltx)
% [A B C] = FIT_EXP(x,y,[A0 B0 C0]) fits an exponential to the data:
%
%        Bx
% Y = A e  + C
%
% Additional argument PLOTX forces a plot of the fit at points in PLOTX.
% Additional output argument CHI2 returns chi^2 value.
% Third output argument returns plot handle.

[par,chi2] = fminsearch(@foo_exp,[A0 B0 C0],[],[x y]);
A=par(1); 
B=par(2);
C=par(3);

if nargin>=6
  p=plot(pltx,A*exp(B*pltx)+C);
end

function chi2=foo_exp(par,xy)
f=par(1)*exp(xy(:,1).*par(2))+par(3);
chi2 = sum((xy(:,2)-f).^2)/(size(xy,1)-3);
