function [pw,ff1] = smospec(ff,pwr,smo,oversample)
% SMOSPEC - Smooth power spectrum
%    pw = SMOSPEC(ff, pw, smo) returns a version of the 
%    power spectrum PW(FF) convolved with a Gaussian of width SMO
%    octaves (in log space).
%    [pw,ff1] = SMOSPEC(ff, pw, smo, oversample) returns a more limited graph:
%    only points every SMO/OVERSAMPLE octaves.

smo=log(2^smo);
if nargin<4
  pw = gaussianinterp(log(ff),log(ff),pwr,smo);
  ff1=ff;
else
  ff1=exp(log(ff(2)):smo/oversample:log(ff(end)));
  pw = gaussianinterp(log(ff1),log(ff),pwr,smo);  
end
if nargout<2
  clear ff1
end
