function xyxy = skeletonize(img)
% SKELETONIZE - Calculate skeletons of objects in binary images
%   xyxy = SKELETONIZE(img) finds all objects (contiguous areas of
%   non-zero pixels as defined through 8-neighborhoods) in the image
%   IMG and skeletonizes each of them using DILERODE. It then uses
%   FIBACKTRACE to convert the skeleton into a list of coordinates.
%   The final output is a cell array with an Nx2 list of (x,y) coordinates
%   for each object.

skl = dilerode(img,'skel');
obj = imobjectify(skl);

K=max(obj(:));
for k=1:K
  obk = obj==k;
  cnt = floodinc(obk);
  [d,mx] = max(cnt(:));
  [x,y] = idx2xy(size(cnt),mx);
  cnt = floodinc(obk,x,y);
  [d,mx]=max(cnt(:));
  [x,y]=idx2xy(size(cnt),mx);
  xy = fibacktrace(cnt,x,y);
  xyxy{k} = xy;
end
