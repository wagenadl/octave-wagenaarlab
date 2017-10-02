function img = gblur2(img,rx,ry,sigmul)
% GBLUR2 - Blur by convolution with a Gaussian
%    img = GBLUR2(img,rx,ry) convolves IMG with 
%
%                   2               2
%       - 1/2 (x/rx)   -  1/2 (y/ry)  
%      e
%
%    If RY is not given, it defaults to RX.
%
%   GBLUR2 works by convolving with a Gaussian defined up to +/- 2*sigma. For
%   most purposes that's enough precision. The multiplier (2) can be specified
%   as a fourth argument to GBLUR2.
%
%   NB: Unlike GSMOOTH, this function does not normalize correctly at the
%   edges.

if nargin<3 || isempty(ry)
  ry=rx;
end

if nargin<4
  sigmul=2;
end

if rx<0
  rx = -rx / (2*sqrt(log(4)));
end

if ry<0
  ry = -ry / (2*sqrt(log(4)));
end

RX = ceil(sigmul*rx);
RY = ceil(sigmul*ry);

bx=exp(-.5*([-RX:RX]/rx).^2);
by=exp(-.5*([-RY:RY]/ry).^2)';

bb = by*bx;
bb = bb ./ sum(bb(:));

img = conv2(img,bb,'same');

