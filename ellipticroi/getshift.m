function [xshift, yshift] = getshift(fr1,fr2)
% shft = GETSHIFT(fr1,fr2) finds the local shift map based on two 
% images FR1 and FR2.

[Y X] = size(fr1);
x0 = ceil(X/32); % i.e. 8 for 254 or 256 pix. First grid point.
dx = ceil(X/12.8); % i.e. 20 for 254 or 256 pix. Spacing between grid points.

sig = ceil(X/12.8); % i.e. 20 for 254 or 256 pix. Scope of initial determination.
sig2 = ceil(X/12.8); % i.e. 20 for 254 or 256 pix. Smoothing radius.

D = ceil(X/25.6); % i.e. 10 for 254 or 256 pix. Max. shift (in pix).

aa = [x0:dx:Y]'; A=length(aa); sig=20; sig2=20;
bb = aa'; B=length(bb);
aa = repmat(aa,[1 B]);
bb = repmat(bb,[A 1]);

xx=repmat([1:X],[Y 1]);
yy=repmat([1:Y]',[1 X]);

shfx = zeros(A,B);
shfy = zeros(A,B);
for a=1:A
  for b=1:B
    [shf,adif] = weighalign(fr1,fr2,exp(-.5*((yy-aa(a,b)).^2+(xx-bb(a,b)).^2)./sig.^2),D);
    shfy(a,b) = shf(1);
    shfx(a,b) = shf(2);
  end
end

xshift = zeros(Y,X);
yshift = zeros(Y,X);
wei = zeros(Y,X);
for b=1:B
  for a=1:A
    if abs(shfx(a,b))==D | abs(shfy(a,b))==D
      ;
    else
      dst = exp(-.5*((xx-bb(a,b)).^2+(yy-aa(a,b)).^2)./sig2.^2);
      wei = wei + dst;
      xshift = xshift + dst*shfx(a,b);
      yshift = yshift + dst*shfy(a,b);
    end
  end
end
xshift = xshift ./ wei;
yshift = yshift ./ wei;
