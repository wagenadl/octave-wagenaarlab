function [img, scf] = upscale(img, fact, minstep, maxstep)
% UPSCALE - Gently upscale an image
%   img = UPSCALE(img, factor) upscales the image IMG by a factor FACTOR.
%   Rather than performing the scaling in one step, which—even when using
%   splines—tends to produce notable square super pixels, scaling is done
%   in small steps of 10 to 25%, in a pseudo-random but determined sequence.
%   img = UPSCALE(img, factor, minstep, maxstep) specifies the minimum
%   and maximum scaling steps. (Default: minstep = 0.10; maxstep = 0.25.)
%   [img, scf] = UPSCALE(...) returns the scaling factors used.
%   The results often end up looking better if followed by gentle unsharpmask.

if nargin>4 || nargin<2 || nargin==3 || fact<1
  error('Usage: img = upscale(img, fact) or upscale(img, fact, s0, s1).');
end

if nargin<4
  minstep = 0.10;
  maxstep = 0.25;
end

[Y0 X0 C] = size(img);
Y1 = round(fact*Y0);
X1 = round(fact*X0);

Y = Y0;
X = X0;
k = 1;
scf = [];
while Y<Y1
  scl = (.5+.5*sin(k*172.1)) * (maxstep-minstep) + 1 + minstep;
  scf(k) = scl;
  k = k + 1;
  Y_ = round(scl*Y);
  X_ = round(scl*X);
  if Y_>=Y1 || X_>=X1
    Y_ = Y1;
    X_ = X1;
  end
  % first pixel in src is at (.5 -- 1.5); last at (Y-.5 -- Y+.5).
  % in dst: (.5 -- 1.5); (Y_-.5 -- Y_+.5)
  yi = [.5:Y_]'/Y_ * Y;
  xi = [.5:X_]/X_ * X;
  yi(yi<1) = 1;
  yi(yi>Y) = Y;
  xi(xi<1) = 1;
  xi(xi>X) = X;
  im0 = img;
  img = zeros([Y_ X_ C]);
  for c=1:C
    img(:,:,c) = interp2(im0(:,:,c), xi, yi, 'spline');
  end
  Y = Y_;
  X = X_;
end

