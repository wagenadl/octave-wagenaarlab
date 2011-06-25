function gmb = gamma_fit(xx,gmb0)
% gmb = GAMMA_FIT(xx,gmb0) fits a gamma pdf to the observations XX using
% Maximum Likelihood (with FMINSEARCH). 
% Initial values are in GMB0 (gamma,mu,beta)

if nargin<2
  gmb0=[1 0 1];
else
end
gmb = fminsearch(@gamma_ml,gmb0,[],xx)
%gmb = fminsearch(@(gmb) gamma_ml(xx,gmb),gmb0);
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ml=gamma_ml(gmb,xx)
p=gamma_pdf(xx,gmb(1),gmb(2),gmb(3));
ml = -sum(log(p+1e-10));
