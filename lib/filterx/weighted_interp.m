function y1 = weighted_interp(x0,y0,x1,w0,sig)
% y1 = WEIGHTED_INTERP(x0,y0,x1,w0,sig) interpolates the data (X0,Y0)
% at the points X1, using weights W0 for the data. A Gaussian of width SIG
% is used for interpolation smoothing.

N=length(x1);
y1=0*x1;
for n=1:N
  dx = x0-x1(n);
  ga = exp(-.5*dx.^2/sig.^2);
  y1(n) = sum(w0.*y0.*ga) ./ sum(w0.*ga);
end
