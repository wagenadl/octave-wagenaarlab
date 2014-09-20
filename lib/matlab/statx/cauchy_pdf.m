function y = cauchy_pdf(x,t,s)
% y = CAUCHY_PDF(x,t,s) returns the value of the Cauchy pdf at X. 
% Default parameter values: T=0, S=1.

if nargin<2
  t=0;
end
if nargin<3
  s=1;
end

y = 1./(s*pi*(1+((x-t)/s).^2));