function chi2=fitdoubleexp(par,data)
  N=length(data);
  t=[1:N];
  f=par(1)*exp(-t/par(2))+par(3)*exp(-t/par(4));
  chi2 = sum((data-f).*(data-f))/(N-4);
% Use as in: par=fminsearch(@fitdoubleexp,[-200,100,100,200],[],data);