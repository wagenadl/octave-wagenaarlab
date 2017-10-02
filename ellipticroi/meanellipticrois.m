function [mn,st,nn] = meanellipticrois(imgs,xyxys)
% [mn,st,nn] = MEANELLIPTICROIS(imgs,xyxys) returns mean, std.dev. and number
% of pixels in each of the elliptic ROIs defined by XYXYS (4xN), from each
% of the images IMGS (XxYxC). 
% Output is CxN+1. Last entry is mean/std/#pix of whole image.
[X Y C]=size(imgs);
[A B]=size(xyxys);
mn=zeros(C,B+1);
st=zeros(C,B+1);
nn=zeros(C,B+1);
for c=1:C
  pxs = extractellipticrois(imgs(:,:,c),xyxys);
  for b=1:B
    mn(c,b) = mean(pxs{b});
    st(c,b) = std(pxs{b});
    nn(c,b) = length(pxs{b});
  end
end
for c=1:C
  pxs = imgs(:,:,c); pxs=pxs(:);
  mn(c,B+1) = mean(pxs);
  st(c,B+1) = std(pxs);
  nn(c,B+1) = length(pxs);
end
