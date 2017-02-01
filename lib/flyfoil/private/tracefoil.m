function [xx, yy] = tracefoil(ifn, dpi, pltflg)
% TRACEFOIL - Traces a foil cut from an image
%    [xx, yy] = TRACEFOIL(ifn, dpi) returns the closed curve in the 
%    image file IFN as close as reasonable given
%    the resolution DPI of that file.
%    TRACEFOIL(ifn, dpi) draws the results rather than returning them.
%    [xx, yy] = TRACEFOIL(ifn, dpi, 1) also draws the results.

if nargin<1
  ifn = 'path26.png';
end
if nargin<2
  dpi = 9600;
end
if nargin<3
  pltflg = 0;
end
if nargout==0
  pltflg = 1;
end

img = imread(ifn);
img = mean(double(img), 3);
img = img>mean(img(:));
[Y X] = size(img);
img = [zeros(Y,3) img zeros(Y,3)];
[Y X] = size(img);
img = [zeros(3,X); img; zeros(3,X)];

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

xx = xy(:,1) / dpi;
yy = xy(:,2) / dpi;
if xx(2)<xx(1)
  xx = flipud(xx);
  yy = flipud(yy);
end
x0 = mean(xx);
y0 = mean(yy);
xx = xx - x0;
yy = yy - y0;

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
  % Let's plot original curve.
  figure(1); clf
  plot(xx, yy, 'k');
  nottiny
  a=max(abs(axis))
  axis([-a a -a a])
  axis square;
end

if nargout==0
  clear xx yy
end

