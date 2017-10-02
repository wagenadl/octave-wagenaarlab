function a=arrow(x,y,w,h,bi)
% a=ARROW(x,y,w,h,bi) draws an arrow from x(1),y(1) to x(2),y(2), with an
% arrow head of relative width w (default is 1/10) and height h (default
% is h=w), and returns an array of line handles.
% If bi is specified and non-zero, two headed arrows are drawn.

if nargin<5
  bi=0;
end
if nargin<3
  w=[];
end
if nargin<4;
  h=[];
end

dx=x(2)-x(1);
dy=y(2)-y(1);

if isempty(w)
  w=.1;
end
if isempty(h)
  h=w;
end

z=axis; DX=z(2)-z(1); DY=z(4)-z(3);
z=get(gca,'position'); Dx=z(3)-z(1); Dy=z(4)-z(2);
pdx=Dx * (dx/DX);
pdy=Dy * (dy/DY);
pr=sqrt(pdx^2+pdy^2);
phi=atan2(pdy,pdx);

w=w*pr; h=h*pr;

scx=DX/Dx; scy=DY/Dy;

a=zeros(1,3+2*(bi~=0));
a(1)=line(x,y);
a(2)=line([0 -w*sin(phi)-h*cos(phi)]*scx+x(2),[0 +w*cos(phi)-h*sin(phi)]*scy+y(2));
a(3)=line([0 +w*sin(phi)-h*cos(phi)]*scx+x(2),[0 -w*cos(phi)-h*sin(phi)]*scy+y(2));
if bi~=0
  a(4)=line([0 -w*sin(phi)+h*cos(phi)]*scx+x(1),[0 +w*cos(phi)+h*sin(phi)]*scy+y(1));
  a(5)=line([0 +w*sin(phi)+h*cos(phi)]*scx+x(1),[0 -w*cos(phi)+h*sin(phi)]*scy+y(1));
end

