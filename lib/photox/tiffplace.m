function img = tiffplace(img, lyr, ifo, rx)
% TIFFPLACE - Overlay a new layer on an existing tiff image
%   img = TIFFPLACE(img, lyr, ifo) places the image LYR in the existing
%   image IMG at a location defined by IFO. The image IMG is expanded as
%   necessary.
%   Alpha compositing is performed if LYR has an alpha channel.
%   img = TIFFPLACE(img, lyr, ifo, rx) first creates ramps and blends 
%   accordingly.
%   The alpha channel must be on a 0-1 scale.

if nargin<4
  rx=[];
end

% Shift new image (add alpha channel if needed).
dx = floor(ifo.xpos*ifo.xreso+.5);
dy = floor(ifo.ypos*ifo.yreso+.5);
[Y X C] = size(lyr);
if C<4
  lyr = cat(3,lyr,ones([Y X 1]));
  [Y X C] = size(lyr);
end
lyr = cat(1,zeros([dy X C]), lyr);
[Y X C] = size(lyr);
lyr = cat(2,zeros([Y dx C]), lyr);
[Y X C] = size(lyr);

% Shift other image (add alpha channel if needed).
if isempty(img)
  img=zeros([Y X C]);
end
[Y_ X_ C_] = size(img);
if Y_<Y
  img=cat(1,img,zeros([Y-Y_ X_ C_]));
  [Y_ X_ C_] = size(img);
end
if X_<X
  img=cat(2,img,zeros([Y_ X-X_ C_]));
  [Y_ X_ C_] = size(img);
end
if C_==3
  img=cat(3,img,ones([Y X]));
end


if isempty(rx)
  % Simple alpha compositing
  % New = alpha_top * top  +
  %       (1-alpha_top) * (alpha_top*top+alpha_bot*bot) / (alpha_top+alpha_bot)
  atop = lyr(1:Y,1:X,4);
  if max(atop(:))>1
    atop=atop/255;
    lyr(:,:,4) = lyr(:,:,4)/255;
  end
  abot = img(1:Y,1:X,4);
  for c=1:C
    img(1:Y,1:X,c) = atop.*lyr(1:Y,1:X,c) + ...
	(1-atop).*(atop.*lyr(1:Y,1:X,c)+abot.*img(1:Y,1:X,c)) ./ (atop+abot+1e-9);
  end
else
  % Ramp compositing
  topramp = tiffalpharamp(tiffalpharamp(lyr(1:Y,1:X,4),rx)',rx)';
  botramp = tiffalpharamp(tiffalpharamp(img(:,:,4),rx)',rx)';
  botramp = botramp(1:Y,1:X,:);
  atop = topramp.^2./(topramp.^2+botramp.^2+1e-9);
  for c=1:3
    img(1:Y,1:X,c) = atop.*lyr(1:Y,1:X,c) + (1-atop).*img(1:Y,1:X,c);
  end
  img(1:Y,1:X,4) = lyr(1:Y,1:X,4)>0 | img(1:Y,1:X,4)>0;
end

