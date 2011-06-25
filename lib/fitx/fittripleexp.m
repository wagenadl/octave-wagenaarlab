function chi2=fittripleexp(par,data)
  N=length(data);
  t=[1:N];
  f=par(1)*exp(-t/par(2))+par(3)*exp(-t/par(4))+par(5)*exp(-t/par(6));
  chi2 = sum((data-f).*(data-f))/(N-6);
  