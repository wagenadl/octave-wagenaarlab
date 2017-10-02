function img = unsharpmask(img, radius, amount, thresh)
% UNSHARPMASK - Sharpening through subtraction of Gaussian blur
%   img = UNSHARPMASK(img, radius, amount) performs unsharp mask as in
%   GIMP. 
%   img = UNSHARPMASK(img, radius, amount, thresh) operates mainly on pixels
%   where the difference is greater than THRESH. A suitable value for THRESH
%   might be 0.01 if images are normalized to 0..1.
%   (Unlike in GIMP, where—if I am not mistaken—the threshold is hard, we
%   use a soft threshold using a sigmoid curve.)

S = ceil(1.5*radius);
xx = [-S:S];
zz = exp(-0.5 * xx.^2 ./ radius.^2);
zz = zz / sum(zz);
msk = convn(img, zz, 'same');
msk = convn(msk, zz', 'same');

if nargin>=4
  msk = img - msk;
  scl = .5 + .5*tanh(3 * (abs(msk)/thresh - 1));
  img = img + amount * scl .* msk;
else
  img = img + amount * (img - msk);
end
