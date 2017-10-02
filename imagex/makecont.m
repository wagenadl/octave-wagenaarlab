function img=makecont(ifn,ofn,geom)
% MAKECONT - Make an image continuously tileable
%   img = MAKECONT(img) creates a tilable image out of the given image.
%   img = MAKECONT(img,[x0 y0 w h]) first grabs a subregion.
%   MAKECONT(ifn,ofn) loads and saves from and to the given files.
%   MAKECONT(ifn,ofn,[x0 y0 w h]) also grabs a subregion.

PLOTFLAG = 0;
slope = 20;

if ischar(ifn)
  img=imread(ifn);
  if nargin>=3
    img = makecont(img,geom);
  else
    img = makecont(img);
  end
  imwrite(img,ofn);
  return
end

img = ifn;
if nargin>=2
  geom=ofn;
else
  geom=[];
end

if ~isempty(geom)
  img=img(geom(2):geom(2)+geom(4)-1,geom(1):geom(1)+geom(3)-1,:);
end

wasint = isinteger(img);
if wasint
  img = double(img)/255;
end

if PLOTFLAG
  figure(1);
  image(repmat(img,[2 2 1]));
  axis square
end

[Y X C] = size(img);
X0=ceil(X/2);
Y0=ceil(Y/2);
im1 = [img(:,X0+1:end,:) img(:,1:X0,:)];
xx=[0:X-1]/(X-1) * 2 - 1;

crv = tanh(slope*(abs(xx)-.5))/2 + .5;

im2 = img.*repmat(1-crv,[Y 1 C]) + im1.*repmat(crv,[Y 1 C]);

if PLOTFLAG
  figure(2);
  image(repmat(im2,[2 2 1]));
end

im1 = [im2(Y0+1:end,:,:); im2(1:Y0,:,:)];
yy=[0:Y-1]'/(Y-1)*2-1;

crv = tanh(slope*(abs(yy)-.5))/2 + .5;
im1 = im2.*repmat(1-crv,[1 X C]) + im1.*repmat(crv,[1 X C]);

if PLOTFLAG
figure(3);
  image(repmat(im1,[2 2 1]));
  axis square
end

img = im1;

if wasint
  img = uint8(img*255);
end
