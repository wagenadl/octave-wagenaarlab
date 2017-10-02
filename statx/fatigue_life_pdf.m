function y = fatigue_life_pdf(x,gamma,mu,beta)
% y = FATIGUE_LIFE_PDF(x,gamma,mu,beta) returns the value of the 
% Fatigue Life pdf at X. 
% Default parameter values: GAMMA=1, MU=0, BETA=1

if nargin<2
  gamma=1;
end
if nargin<3
  mu=0;
end
if nargin<4
  beta=1;
end

z = sqrt((x-mu)/beta);

y = (z+1./z)./(2*gamma*(x-mu)) .* normpdf((z-1./z)/gamma);

y(x<mu)=0;