function greyspikehist(tt,yy,xywh,nmax,pwr,blr)
% GREYSPIKEHIST(tt,yy,xywh) plots a grey-scale raster plot
% xywh = [x0 y0 mulx muly], default is [0 0 1 1].
% GREYSPIKEHIST(tt,yy,xywh,nmax,pwr,blr) specficies caxis limits,
% scale power, and blurring

if nargin<3 | isempty(xywh)
  xywh=[0 0 1 1];
end
if nargin<4 | isempty(nmax)
  nmax = max(yy(:));
end
if nargin<5 | isempty(pwr)
  pwr = 1;
end
if nargin<6
  blr=[];
end

dt = tt(end) - tt(1); dx = dt*xywh(3);
dy = 59*xywh(4);

x0 = xywh(1) + tt(1)*xywh(3);
y0 = xywh(2);
x1 = x0 + dx;
y1 = y0 + dy;

clr = (yy./nmax).^pwr;
if ~isempty(blr)
  clr = gaussianblur1d(clr',blr)';
end
clr(clr>1)=1;

image([x0 x1],[y0 y1],repmat(uint8(255.99-clr*255.99),[1 1 3]));
