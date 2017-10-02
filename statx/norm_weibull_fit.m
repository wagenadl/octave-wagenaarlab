function msap = norm_weibull_fit(xx,msap0)
% msap = NORM_WEIBULL_FIT(xx,msap0) fits a pdf to the observations XX using
% Maximum Likelihood (with FMINSEARCH). 
% The pdf is a homebrew invention: 
%
%   P(x) = p*N(x;mu,sigma)+(1-p)*Weibull(x;alpha,mu,sigma)
%
% Initial values are in MSAP0 (mu,sigma,alpha,p)

if nargin<2
  msap0=[0 1 1 .5];
end

msap0(4)=sqrt(msap0(4));

[msap ,fv,er]= fminsearch(@(msap) -nw_ml(xx,msap),msap0);

if er<=0
  msap = nan + msap;
end

msap(4)=msap(4).^2;
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ml=nw_ml(xx,msap)
pn=norm_pdf(xx,msap(1),msap(2));
pw=weibull_pdf(xx,msap(3),msap(1),msap(2));
p=pn*msap(4).^2+pw*(1-msap(4).^2);
ml = sum(log(p+1e-10));
