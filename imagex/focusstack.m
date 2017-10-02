function [img, d1] = focusstack(imgs, r, alpha, R)
% FOCUSSTACK - Combine images by focus stacking
%    img = FOCUSSTACK(imgs) combines the images in the stack IMGS by weighted
%    averaging. The weights of the individual images are determined at each
%    pixel by the local sharpness.
%    img = FOCUSSTACK(imgs, r) specifies the radius for determining sharpness.
%    R may be a single number or a [y x] pair. Default: R = 6.
%    img = FOCUSSTACK(imgs, r, alpha) specifies the exponent used in the
%    averaging. Larger values of ALPHA push the averaging function toward
%    winner-take-all. Default: ALPHA=3.

if nargin<4
  R = 1;
end
if nargin<3
  alpha = 3;
end
if nargin<2
  r = 6;
end
if length(r)<2
  r = [r r];
end
if length(R)<2
  R = [R R];
end

[Y X F] = size(imgs);

if 0
  d1 = zeros([Y X F]);
  
  i0 = imgs(2:end-1,2:end-1,:);
  i1 = imgs(1:end-2,2:end-1,:)+imgs(3:end,2:end-1,:) + ...
      imgs(2:end-1,1:end-2,:) + imgs(2:end-1,3:end,:);
  d1(2:end-1,2:end-1,:) = (i0 - i1/4) ./ ((i0+i1/4)/2+gamma).^beta;
  d1 = d1.^2;
else
  yy = [-2*R(1):2*R(1)]';
  xx = [-2*R(2):2*R(2)];
  g = exp(-.5*xx.^2/R(2)^2);
  g = g ./ sum(g);
  i0 = convnorm(imgs, g);
  g = exp(-.5*yy.^2/R(1)^2);
  i0 = convnorm(i0, g);
  d1 = (imgs-i0);
  d1 = d1.^2;
end

yy = [-2*r(1):2*r(1)]';
xx = [-2*r(2):2*r(2)];
g = exp(-.5*xx.^2/r(2)^2);
g = g ./ sum(g);
d1 = convnorm(d1, g);
g = exp(-.5*yy.^2/r(1)^2);
d1 = convnorm(d1, g);
d1 = d1.^alpha;
d1 = d1./repmat(sum(d1, 3), [1 1 F]);
img = sum(imgs.*d1, 3);
