function imout = applyshift(imgs,xshift,yshift)
% imgs = APPLYSHIFT(imgs,xshift,yshift) applies the shift (XSHIFT,YSHIFT),
% obtained from GETSHIFT (or MAKESHIFT), to the stack of images IMGS.

[Y X N] = size(imgs);
% D=ceil(max(abs([xshift(:); yshift(:)]))); % could use this to drop edges...
[xx,yy] = meshgrid([1:X],[1:Y]);
[Y_ X_]=size(xx);
imout = repmat(imgs(1,1,1),[Y_ X_ N]); % Crazy way to create same type as imgs.
for n=1:N
  imout(:,:,n) = interp2([1:X],[1:Y],double(imgs(:,:,n)),xx+xshift,yy+yshift,'*spline');
end
