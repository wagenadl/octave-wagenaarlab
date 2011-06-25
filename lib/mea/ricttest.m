function y=ricttest(ric,base)
% y=RICTTEST(ric,base) returns the t value for the width centroid and
% the height centroid of RIC vs BASE. Both RIC and BASE must be
% structures with w0,h0,ww,hh,wh,n members as returned by ROLECLUSTER.
% Covariance is ignored.
% Output is a structure with members t_width, t_height, p_width,
% p_height. t_xxx are the t values, and p_xxx is the integrated
% probability of observing such a value (which approaches 0 or 1 if
% the centroids are far apart, or .5 if they are the same).
% This uses algebra from Barlow, "Intr. to stats", copied in DW, "Pat
% det & ana (2001)" pp17ff. 
% In addition, P_width and P_height (note the capital P) contain the
% two-tailed probabilities (i.e. p=.025 -> P=.05, p=.975 -> P=.05).

if (ric.n<2) | (base.n<2)
  % If (no info) Then Return (boring stuff)
  y.t_width=0;
  y.p_width=.5;
  y.P_width=1;
  y.t_height=0;
  y.p_height=.5;
  y.P_height=1;
  return
end
tw=studentt(ric.w0,ric.ww,ric.n, base.w0,base.ww,base.n);
th=studentt(ric.h0,ric.hh,ric.n, base.h0,base.hh,base.n);
pw=tcdf(tw,ric.n+base.n-2);
ph=tcdf(th,ric.n+base.n-2);
y.t_width=tw;
y.t_height=th;
y.p_width=pw;
y.p_height=ph;
if pw<.5
  y.P_width = 2*pw;
else
  y.P_width = 2 - 2*pw;
end
if ph<.5
  y.P_height = 2*ph;
else
  y.P_height = 2 - 2*ph;
end
return;

function t=studentt(mu1,sig1,n1, mu2,sig2,n2) 
% mux=mean, sigx=var (not stddev!)
SS=((n1-1)*sig1 + (n2-1)*sig2)/(n1+n2-2);
t=(mu1-mu2)/sqrt(SS*(1/n1+1/n2));