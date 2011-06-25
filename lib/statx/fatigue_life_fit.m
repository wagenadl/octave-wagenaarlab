function gmb = fatigue_life_fit(xx,gmb0)
% gmb = FATIGUE_LIFE_FIT(xx,gmb0) fits a fatigue_life pdf to the observations XX using
% Maximum Likelihood (with FMINSEARCH). 
% Initial values are in GMB0 (fatigue_life,mu,beta)

if nargin<2
  gmb0=[1 0 1];
else
end
[gmb,fv,er] = fminsearch(@fatigue_life_ml,gmb0,[],xx);
%[gmb,fv,er] = fminsearch(@(gmb) -fatigue_life_ml(xx,gmb),gmb0);

if er<=0
  gmb = nan + gmb;
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ml=fatigue_life_ml(gmb,xx)
p=fatigue_life_pdf(xx,gmb(1),gmb(2),gmb(3));
ml = -sum(log(p+1e-10));
