function img = redgreensc(varargin)
% REDGREENSC - Overlays two images in red and green
%    REDGREENSC(img1, img2) does the equivalent of IMAGESC on each of
%    the two images and plots them as red and green channels.
%    REDGREENSC(img1, img2, clr1, clr2) specifies alternative colors.
%    REDGREENSC(img1, img2, img3) or
%    REDGREENSC(img1, img2, img3, clr1, clr2, clr3) specifies a third channel.
%    img = REDGREENSC(...) returns an RGB image instead of plotting.

img1=varargin{1};
img2=varargin{2};
img3=0*img1;
clr1 = [1 0 0];
clr2 = [0 1 0];
clr3 = [0 0 1];
if nargin==3 | nargin==6
  img3=varargin{3};
end
if nargin==4 | nargin==6
  clr1=varargin{4};
  clr2=varargin{5};
end
if nargin==6
  clr3=varargin{6};
end

m1 = min(img1(:));
M1 = max(img1(:));
m2 = min(img2(:));
M2 = max(img2(:));
m3 = min(img3(:));
M3 = max(img3(:));


img1 = (img1-m1)./(M1-m1);
img2 = (img2-m2)./(M2-m2);
if M3>m3
  img3 = (img3-m3)./(M3-m3);
else
  img3 = 0*img3;
end

[Y X] = size(img1);
img = zeros([Y X 3]);
for c=1:3
  img(:,:,c) = img1*clr1(c) + img2*clr2(c) + img3*clr3(c);
end

img(img<0)=0;
img(img>1)=1;

if nargout==0
  image(img);
  clear img;
end
