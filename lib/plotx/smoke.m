function [pic,xx,yy]=smoke(x,y,x0,dx,x1,y0,dy,y1);
% pic = SMOKE(x,y,x0,dx,x1,y0,dy,y1) creates a smokey 2D histogram
% [pic,xx,yy] also returns x and y coordinates for use with SURF.
% With no output arguments, the function creates a plot.
% SMOKE(x,y) uses a default picture size
% SMOKE(x,y,nx) uses a prescribed picture size (square) with automatic limits
% SMOKE(x,y,nx,ny) uses a prescribed picture size with automatic limits
% [pic,xx,yy] = ... also returns x and y coordinates for use with SURF.
% With no output arguments, the function creates a plot.

if nargin<2 || (nargin>4 & nargin<8) || nargin>8
  error('Usage: smoke x y x0 dx x1 y0 dy y1; smoke x y nx ny; smoke x y n');
end
if nargin==2
  X=1000;
  Y=1000;
elseif nargin==3
  X=x0; 
  Y=X;
elseif nargin==4
  X=x0;
  Y=dx;
end
if nargin<=4
  x0=min(x); x1=max(x); dx=(x1-x0)/X;
  y0=min(y); y1=max(y); dy=(y1-y0)/Y;
else
  X=ceil((x1-x0)/dx);
  Y=ceil((y1-y0)/dy);
end

x=floor((x-x0)/dx+1);
y=floor((y-y0)/dy+1);
ok=find(x>0 & x<=X & y>0 & y<Y);
pic=zeros(X,Y);
a=x(ok)+X*(y(ok)-1);

if nargout>0
  pic=reshape(hist(a,[1:X*Y]),X,Y);
  if nargout>1
    xx=[x0:dx:x1]; xx=xx(1:X);
    if nargout>2
      yy=[x0:dx:y1]; yy=yy(1:Y);
    end
  end
else
  p=reshape(hist(a,[1:X*Y]),X,Y);
  x=[x0:dx:x1]; x=x(1:X);
  y=[y0:dy:y1]; y=y(1:Y);
  surf(repmat(x',1,Y),repmat(y,X,1),p);
  shading interp
  view(0,90);
  axis tight
end
