function [yy,sy] = ginterp(xx0,yy0,xx,rx)
% GINTERP - Gaussian interpolation in one dimension
%    yy = GINTERP(xx0,yy0,xx,rx) interpolates the data (XX0,YY0) at points XX
%    using a Gaussian window of radius RX. RX is the sigma of the Gaussian.
%    Sometimes one prefers to use the FWHM instead. To do that, call
%    yy = GINTERP(xx0,yy0,xx,-fwhm).
%
%    [yy,sy] = GINTERP(...) also returns error estimates. These are based on
%    the actual distance of YY0 to the interpolation curve, and the effective
%    number of points used to calculate each interpolated point. 
%    NB - I am not sure that I am doing the right thing here: If for a given
%    location in the output curve, data points have weights w_i, I declare
%    the "effective" number of points affecting this part of the curve to be
%    sum(w_i) / max(w_i). Does that sound reasonable?
%
%    GINTERP currently only operates on vectors.

if rx<0
  rx = -rx / (2*sqrt(log(4)));
end

N = length(xx);
yy = zeros(size(xx));
for n=1:N
  wei = exp(-.5*((xx(n)-xx0)/rx).^2);
  wei = wei / sum(wei);
  yy(n) = sum(wei.*yy0);
end

if nargout>=2
  sy = zeros(size(xx));
  y_i = interp1(xx,yy,xx0,'linear'); % approximate smoothed fn at orig. pts
  s_i = yy0-y_i;
  bad=isnan(s_i);
  s_i(bad)=0;
  for n=1:N
    wei = exp(-.5*((xx(n)-xx0)/rx).^2);
    wei(bad)=0;
    wei = wei / sum(wei);
    eff_n = 1 / max(wei); % Actually, sum(wei)/max(wei), but sum(wei)=1 by def.
    sy(n) = sqrt(sum(wei.*s_i.^2)) / sqrt(eff_n);
  end
end
