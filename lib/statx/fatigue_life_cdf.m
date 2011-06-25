function y = fatigue_life_cdf(x,gamma,mu,beta)

% y = FATIGUE_LIFE_PDF(x,gamma,mu,beta) returns the cdf of the 
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

ok=x>mu;
z=sqrt((x-mu)/beta); 
arg=(z-1./z)./gamma;
y=0*x;
y(ok)=normcdf(arg(ok));
