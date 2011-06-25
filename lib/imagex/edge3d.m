function img = edge3d(img,varargin)
% EDGE3D - Add an edge with 3D look to an image
%    img = EDGE3D(img) adds a border of 2 pixels to the image
%    img = EDGE3D(img, key1,value1, ...) sets additional options
%    Possible options are:
%      radius: radius of edge, in pixels (default: 2 px).
%      strength: strength of operation, fraction of brightness (default: 0.5).
%      smooth: smoothing of edge: 0: hard edge, 1: smooth over radius, or
%              any value in between (default: 0.5).
%    img = EDGE3D([Y X], ...) creates just a map to be multiplied into 
%    images later.

kv = getopt('radius=2 strength=0.5 smooth=0.5', varargin);

if length(img(:))==2
  Y = img(1);
  X = img(2);
  img = ones(Y,X);
  mustclip = 0;
else
  mustclip = 1;
end

[Y X C]=size(img);
wasint = isinteger(img);
if wasint
  img = double(img)/255;
end


xx=repmat([1:X],[Y 1]);
yy=repmat([1:Y]',[1 X]);

kv.smooth = max(kv.smooth,1e-9);
kv.smooth = min(kv.smooth,1);

chg = kv.strength * ((.5-.5*tanh((xx-.5-kv.radius)/kv.smooth)) + ...
    (.5-.5*tanh((yy-.5-kv.radius)/kv.smooth))) - ...
    (.5-.5*tanh((X+.5-xx-kv.radius)/kv.smooth)) - ...
    (.5-.5*tanh((Y+.5-yy-kv.radius)/kv.smooth));

for c=1:C
  img(:,:,c) = img(:,:,c) .* (1+chg);
end

if mustclip
  img(img>1)=1;
end

if wasint
  img = uint8(img*255);
end
