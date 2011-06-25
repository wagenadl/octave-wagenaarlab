function img = imagepat(pats,fgs,bgs,siz)
% IMAGEPAT   Creates a patterned image
%    img = IMAGEPAT(pats,fgs,bgs,siz) creates an image of patterns.
%    PATS (XxY) specifies which pattern is used for 'pixel' (x,y),
%    coded as per PATTERN.
%    FGS (XxY) specfies the foreground colors.
%    BGS (XxY) specifies the background colors.
%    SIZ (scalar) specifies the size of each pixel.

[X Y]=size(pats);
img = zeros(X*siz,Y*siz,3);
for x=1:X
  for y=1:Y
    img((x-1)*siz+[1:siz],(y-1)*siz+[1:siz],:) = pattern(pats(x,y),fgs(x,y,:),bgs(x,y,:),siz);
  end
end
