function [xx, yy] = tracefoil(ifn, dpi, clr, pltflg)
% TRACEFOIL - Traces a foil cut from an image
%    [xx, yy] = TRACEFOIL(ifn, dpi) returns the closed curve in the 
%    image file IFN as close as reasonable given
%    the resolution DPI of that file.
%    [xx, yy] = TRACEFOIL(ifn, dpi, clr) specifies color to look for.
%    Set CLR=[] to select any color
%    TRACEFOIL(ifn, dpi) draws the results rather than returning them.
%    [xx, yy] = TRACEFOIL(ifn, dpi, clr, 1) also draws the results.

if nargin<1
  ifn = 'path26.png';
end
if nargin<2
  dpi = 9600;
end
if nargin<3
  clr = [];
end
if nargin<4
  pltflg = 0;
end
if nargout==0
  pltflg = 1;
end

img = imread(ifn);
im0 = mean(double(img), 3);
im0 = im0>mean(im0(:));
if isempty(clr)
  img = im0;
else
  img = double(img);
  img = ((img(:,:,1)-clr(1)).^2 + (img(:,:,2)-clr(2)).^2 + (img(:,:,3)-clr(3)).^2) < 5;
end
[Y X] = size(img);
img = [zeros(Y,3) img zeros(Y,3)];
[Y X] = size(img);
img = [zeros(3,X); img; zeros(3,X)];
[Y X] = size(img);
[Y X] = size(im0);
im0 = [zeros(Y,3) im0 zeros(Y,3)];
[Y X] = size(im0);
im0 = [zeros(3,X); im0; zeros(3,X)];
[Y X] = size(im0);

skl = dilerode(img, 'skel');
obj = imobjectify(skl);
idx = find(obj>0);
[y, x] = ind2sub(size(obj), idx);
y0 = min(y);
idx = idx(y==y0);
N = ceil(length(idx)/2);

obj(idx(N))=0; % Break the object
cnt = floodinc(obj==1);
[~,idx] = max(cnt(:));
[y, x] = ind2sub(size(obj), idx);
cnt = floodinc(obj==1, x, y);
[~,idx] = max(cnt(:));
[y, x] = ind2sub(size(obj), idx);
xy = fibacktrace(cnt, x, y);

xx = (xy(:,1) - (X+1)/2) / dpi;
yy = (xy(:,2) - (Y+1)/2) / dpi;
if xx(2)<xx(1)
  xx = flipud(xx);
  yy = flipud(yy);
end
if 0
  x0 = mean(xx);
  y0 = mean(yy);
  xx = xx - x0;
  yy = yy - y0;
end

% So now we have x and y coordinates, converted to inches

% Let's smooth that just a bit
L = length(xx);
L2 = round(L/2);
S = 5; R = round(2*S);
xx = [xx(L2+1:end); xx; xx(1:L2)];
yy = [yy(L2+1:end); yy; yy(1:L2)];
g = exp(-.5*[-R:R]'.^2/S.^2);
g = g./sum(g);
xx = conv(xx, g, 'same');
yy = conv(yy, g, 'same');
xx = xx(1+L-L2:2*L-L2);
yy = yy(1+L-L2:2*L-L2);
xx(end+1) = xx(1);
yy(end+1) = yy(1);

if pltflg
  % Let's plot curve on image.
  figure(1); clf
  imagesc(([1:X]-(X+1)/2)/dpi * 25.4, ([1:Y]-(Y+1)/2)/dpi * 25.4, img + im0/2);
  colormap(1-gray);
  hold on
  plot(xx * 25.4, yy * 25.4, 'g');
  nottiny
  axis tight;
  a=max(abs(axis))*1.05;
  axis([-a a -a a])
  axis square;
  title 'Original image and extracted curve'
end


if nargout==0
  clear xx yy
end

