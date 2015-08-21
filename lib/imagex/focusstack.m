function img = focusstack(imgs, r, alpha)
% FOCUSSTACK - Combine images by focus stacking
%    img = FOCUSSTACK(imgs) combines the images in the stack IMGS by weighted
%    averaging. The weights of the individual images are determined at each
%    pixel by the local sharpness.
%    img = FOCUSSTACK(imgs, r) specifies the radius for determining sharpness.
%    R may be a single number or a [y x] pair. Default: R = 6.
%    img = FOCUSSTACK(imgs, r, alpha) specifies the exponent used in the
%    averaging. Larger values of ALPHA push the averaging function toward
%    winner-take-all. Default: ALPHA=3.

if nargin<3
  alpha = 3;
end
if nargin<2
  r = 6;
end
if length(r)<2
  r = [r r];
end

[Y X F] = size(imgs);


d1 = zeros([Y X F]);
i0 = imgs(2:end-1,2:end-1,:);
i1 = imgs(1:end-2,2:end-1,:)+imgs(3:end,2:end-1,:) + ...
    imgs(2:end-1,1:end-2,:) + imgs(2:end-1,3:end,:);
d1(2:end-1,2:end-1,:) = (i0 - i1/4) ./ sqrt((i0+i1)/5+1);
d1 = d1.^2;

yy = [-2*r(1):2*r(1)]';
xx = [-2*r(2):2*r(2)];
g = exp(-.5*xx.^2/r(2)^2);
d1 = convnorm(d1, g./sum(g));
g = exp(-.5*yy.^2/r(1)^2);
d1 = convnorm(d1, g./sum(g));
d1 = d1.^alpha;
d1 = d1./repmat(sum(d1, 3), [1 1 F]);

img = sum(imgs.*d1, 3);
