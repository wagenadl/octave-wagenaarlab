function [ima,imb] = tiffoverlap(img,ifo,l1,l2)
% TIFFOVERLAP - Extract overlap region from multilayer tiff image
%    [ima, imb] = TIFFOVERLAP(img,ifo,l1,l2) extracts the parts of
%    layers L1 and L2 from the multilayer tiff image IMG. IFO must 
%    be the information returned by TIFFINFO; it is used to determine
%    relative positions.

[Y X C] = size(img{l1});
[Y_ X_ C_] = size(img{l2});

xx=[1:X];
yy=[1:Y]';
dx = ifo(l2).xpos*ifo(l2).xreso - ifo(l1).xpos*ifo(l1).xreso;
dy = ifo(l2).ypos*ifo(l2).yreso - ifo(l1).ypos*ifo(l1).yreso;
dx = -floor(dx+.5);
dy = -floor(dy+.5);
xx_ = xx + dx;
yy_ = yy + dy;
usex = find(xx_>=1 & xx_<=X_);
usey = find(yy_>=1 & yy_<=Y_);

ima = img{l1}(usey,usex,:);
imb = img{l2}(usey+dy,usex+dx,:);
