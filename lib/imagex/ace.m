function res = ace(img, sigx, rx, sigy, ry)
% ACE - Adaptive contrast enhancement
%   res = ACE(img, sig) calculates an adaptive contrast enhanced image
%   with given sigma.
%   res = ACE(img, sig, r) also specifies a radius (default: 2.5*sig).
%   res = ACE(img, sigx, rx, sigy, ry) specifies sigma and radius separately
%   for X and Y directions.

if nargin<3 || isempty(rx)
  rx = 2.5*sigx;
end
if nargin<4 || isempty(sigy)
  sigy = sigx;
end
if nargin<5 || isempty(ry)
  ry = rx;
end

rx = floor(rx);
ry = floor(ry);

x = [-rx:rx];
y = [-ry:ry]';
gx = exp(-.5*(x.^2/sigx^2));
gy = exp(-.5*(y.^2/sigy^2));
dif = img - convnorm(convnorm(img, gx), gy);
rms = sqrt(convnorm(convnorm(dif.^2, gx), gy));
rms = convnorm(convnorm(rms, gx), gy);
res = dif ./ (rms + mean(rms(:))/4);

  