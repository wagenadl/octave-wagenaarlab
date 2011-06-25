function obj = floodinc(img,x,y)
% FLOODINC - Fills an object with incrementing integers
%   obj = FLOODINC(img,x,y) where IMG is a binary image and (X,Y) is a 
%   location on an object in that image, flood fills the object with 
%   integers indicating the distance from the source pixel.
%
%   The current implementation uses depth-first flood fill, which is
%   a bug; breadth-first would be correct (in the case of looped objects).

if nargin==1
  % Automatically find the object
  idx = find(img>0);
  idx=idx(1);
  [Y X] = size(img);
  y = mod(idx-1,Y) + 1;
  x = div(idx-1,Y) + 1;
end

obj = floodinc_core(uint8(0 + (img>0)),y-1,x-1);
if isa(img,'double')
  obj=double(obj);
end
