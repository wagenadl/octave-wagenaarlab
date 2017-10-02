function [pxs,ins] = extractellipticrois(img,xyxy,r)
% EXTRACTELLIPTICROIS - Get pixels from multiple ROIs
%    pxs = EXTRACTELLIPTICROIS(img,xyrras) returns all pixel values 
%    (not just the average) that fall inside the elliptic ROIs defined 
%    by XYRRAS.  
%    IMG may be a single image or a stack of images (YxXxN).
%    XYRRA must be shaped 5xK. (*Not* Kx5 as one might expect.)
%    This returns a cell array, and is faster than multiple calls to
%    EXTRACTELLIPTICROI.
%    [pxs,ins] = EXTRACTELLIPTICROIS(...) also returns the map on which this
%    extraction is based.
%    pxs = EXTRACTELLIPTICROIS(img,xyrras,r) performs soft-edge extraction,
%    with a edge width of R. This returns a regular array rather than a cell
%    array.
%    
%    NOTE: if ellipses overlap partially, pixels get assigned only to the
%    lower-numbered ellipse. This is different than the result of using
%    EXTRACTELLIPTICROI individidually for each ellipse.

if nargin<3
  r=0;
end

xyrra = normellipse(xyxy);

[Y X C]=size(img);

xx = repmat([1:X],[Y 1]);
yy = repmat([1:Y]',[1 X]);
ins = uint8(zeros(Y,X));
[A N]=size(xyrra);
for n=N:-1:1 % Reverse order to get desired priority
  x_ = xx-xyrra(1,n);
  y_ = yy-xyrra(2,n);
  xi =  x_*cos(xyrra(5,n))+y_*sin(xyrra(5,n));
  eta = -x_*sin(xyrra(5,n))+y_*cos(xyrra(5,n));
  ins((xi/xyrra(3,n)).^2 + (eta/xyrra(4,n)).^2 < 1) = n;
end

if r>0
  pxs = zeros(N,1);
else
  pxs = cell(1,N);
end

for n=1:N
  if r>0
    x_ = xx-xyrra(1,n);
    y_ = yy-xyrra(2,n);
    xi =  x_*cos(xyrra(5,n))+y_*sin(xyrra(5,n));
    eta = -x_*sin(xyrra(5,n))+y_*cos(xyrra(5,n));
    r0 = sqrt(xyrra(3,n)^2 + xyrra(4,n)^2);
    rat = r0 .* (sqrt((xi/xyrra(3,n)).^2 + (eta/xyrra(4,n)).^2) - 1);
    wei = (ins==n) .* (.5-.5*tanh(rat));
    pxs(n) = sum(img(:).*wei(:))./sum(wei(:));
  else  
    pxs{n} = img(ins==n);
  end
end
