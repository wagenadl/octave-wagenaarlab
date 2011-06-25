function y = gamma_pdf(x,gam,mu,beta)
% y = GAMMA_PDF(x,gamma,mu,beta) returns the value of the 
% Gamma pdf at X. 
% Default parameter values: GAMMA=1, MU=0, BETA=1

if nargin<2
  gam=1;
end
if nargin<3
  mu=0;
end
if nargin<4
  beta=1;
end

z = (x-mu)/beta;

y = z.^(gam-1) .* exp(-z) ./ (beta*gamma(gam));
y(z<0)=0;