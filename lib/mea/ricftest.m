function y=ricftest(ric,base)
% y=RICFTEST(ric,base) returns the F value for the width variance and
% the height variance of RIC vs BASE. Both RIC and BASE must be
% structures with w0,h0,ww,hh,wh,n members as returned by ROLECLUSTER.
% Only ww,hh,n are used. In particular, covariance is ignored.
% Output is a structure with members F_width, F_height, p_width,
% p_height. F_xxx are the F values, and p_xxx is the integrated
% probability of observing such a value if RIC and BASE are samples
% from the same Gaussian (which approaches 0 if RIC is much narrower
% than BASE, .5 if they are the same, or 1 if RIC is much wider).

if (ric.n<2) | (base.n<2)
  % If (no info) Then Return (boring stuff)
  y.F_width=1;
  y.p_width=.5;
  y.F_height=1;
  y.p_height=.5;
  return
end
  

Fh=ric.hh/base.hh;
ph=fcdf(Fh,ric.n-1,base.n-1);
Fw=ric.ww/base.ww;
pw=fcdf(Fw,ric.n-1,base.n-1);
y.F_height=Fh;
y.F_width=Fw;
y.p_height=ph;
y.p_width=pw;

% function p=Fprob(F,f_num,f_denom)
% Gaussian approximation outlined in DW, Pat det & ana (2001) pp17ff.

%Z=.5*log(F);
%mu=.5*(1/f_num-1/f_denom);
%ss=.5*(1/f_num+1/f_denom);
%x=(Z-mu)/sqrt(ss);
%% So now x is approx Normal(0,1) distributed