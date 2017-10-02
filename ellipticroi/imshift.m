function out = imshift(imgs,dx,dy,R)
% IMSHIFT - Returns the central area of a stack of images, shifted
%    out = IMSHIFT(imgs,dx,dy,R) shifts the image stack IMGS (YxXxT)
%    by the amounts DX (Tx1) and DY (Tx1), and strips of R pixels on all
%    sides.

[Y X T]=size(imgs);
out = zeros([Y-2*R X-2*R T]);
[Y_ X_ T_]=size(out);
for t=1:T
  xx=[1+R:X-R]+dx(t);
  yy=[1+R:Y-R]'+dy(t);
  out(:,:,t) = interp2(imgs(:,:,t),repmat(xx,[Y_ 1]),repmat(yy,[1 X_]),'spline');
end

  