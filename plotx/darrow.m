function a=darrow(x,y,w,h,bi)
% a=DARROW(x,y,w,h,bi) draws an arrow from X(1),Y(1) to X(2),Y(2), with an
% arrow head of width W (default is 1/10") and height H (default is h=w),
% and returns an array of line handles.
% If BI is specified and non-zero, two headed arrows are drawn.
% Note that W and H are specified in inches.

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

[x_sc,y_sc]=oneinch;

dx = diff(x);
dy = diff(y);
dx_inch = dx / x_sc;
dy_inch = dy / y_sc;

phi = atan2(dy_inch,dx_inch); % Angle of arrow on paper

a=zeros(1,3+2*(bi~=0));

a(1)=line(x,y);

a(2)=line([0 -w*sin(phi)-h*cos(phi)]*x_sc+x(2),[0 +w*cos(phi)-h*sin(phi)]*y_sc+y(2));
a(3)=line([0 +w*sin(phi)-h*cos(phi)]*x_sc+x(2),[0 -w*cos(phi)-h*sin(phi)]*y_sc+y(2));
if bi~=0
  a(4)=line([0 -w*sin(phi)+h*cos(phi)]*x_sc+x(1),[0 +w*cos(phi)+h*sin(phi)]*y_sc+y(1));
  a(5)=line([0 +w*sin(phi)+h*cos(phi)]*x_sc+x(1),[0 -w*cos(phi)+h*sin(phi)]*y_sc+y(1));
end

