function obj = imobjectify(img)
% IMOBJECTIFY - Assign positive integers to objects in images
%   obj = IMOBJECTIFY(img) flood fills each object in the binary image IMG 
%   with different integers. The object most closely to the top left is 
%   numbered 1, the next one number 2, etc.
%
%   This uses 8-neighborhoods for connectedness.
%
%   The implementation uses recursion, which is not optimal for big images,
%   unless all objects are skeletons (e.g. from DILERODE(...,'skel')).

obj = imobjectify_core(uint8(0 + (img>0)));
if isa(img,'double')
  obj = double(obj);
end
