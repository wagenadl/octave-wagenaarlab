function h = hatchrect(xywh,typ,dxy,xy0)
% HATCHRECT - Draw a hatch pattern in a rectangle.
% h = HATCHRECT(xywh,typ,dxy) fills the rectangle XYWH with a hatch pattern.
% Patterns are specified by TYP, a single character. Valid choices are:
%   '/' - forward slanted
%   '\' - backward slanted
%   '|' - verticals
%   '-' - horizontals
%   'x' - forward and backward slanted
%   '+' - horizontals and verticals
%   '.' - a pattern of dots (NYI)
%   'o' - a pattern of circles (NYI)
% DXY specifies the scale of the pattern. If a scalar, it is the
% distance between lines, in inches.
% For symbol patterns, DXY should be a 2-ple; the 2nd element specifies
% the symbol size, in inches.
% Normally, the pattern is aligned to the middle of the filled area; 
% optional 4th argument XY0 specifies the center, in graph coordinates.
% Return value is an array of line handles.

if nargin<4
  xy0 = [xywh(1)+xywh(3)/2, xywh(2)+xywh(4)/2];
end
if nargin<3 | isempty(dxy)
  dxy=0.1;
end
[dx,dy] = oneinch;
dxy1=dxy(1)*[dx dy];
if length(dxy)>1
  dxy2=dxy(2)*[dx dy];
else
  dxy2=dxy1/3;
end

switch typ
  case '/'
    h=hr_fwdhatch(xywh,xy0,dxy1);
  case '\\'
    h=hr_backhatch(xywh,xy0,dxy1);
  case 'x'
    h=hr_fwdhatch(xywh,xy0,dxy1);
    h=[h;hr_backhatch(xywh,xy0,dxy1)];
  case '|'
    h=hr_verthatch(xywh,xy0,dxy1);
  case '-'
    h=hr_horhatch(xywh,xy0,dxy1);
  case '+'
    h=hr_horhatch(xywh,xy0,dxy1);
    h=[h;hr_verthatch(xywh,xy0,dxy1)];
  case '.'
    h=hr_dothatch(xywh,xy0,dxy1,dxy2,'.');
  case 'o'
    h=hr_dothatch(xywh,xy0,dxy1,dxy2,'o');
  otherwise
    error('hatchrect: unknown TYP');
end
set(h,'color','k');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = hr_verthatch(xywh,xy0,dxy)
h=[];
xl=xywh(1);
xr=xywh(1)+xywh(3);

x0=xy0(1);
while x0<=xl
  x0=x0+dxy(1);
end
while x0<xr
  h=[h;plot([x0 x0],xywh(2)+[0 xywh(4)])];
  x0=x0+dxy(1);
end

x0=xy0(1)-dxy(1);
while x0>=xr
  x0=x0-dxy(1);
end
while x0>xl
  h=[h;plot([x0 x0],xywh(2)+[0 xywh(4)])];
  x0=x0-dxy(1);
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = hr_horhatch(xywh,xy0,dxy)
h=[];
yb=xywh(2);
yt=xywh(2)+xywh(4);

y0=xy0(2);
while y0<=yb
  y0=y0+dxy(2);
end
while y0<yt
  h=[h;plot(xywh(1)+[0 xywh(3)],[y0 y0])];
  y0=y0+dxy(2);
end

y0=xy0(2)-dxy(2);
while y0>=yt
  y0=y0-dxy(2);
end
while y0>yb
  h=[h;plot(xywh(1)+[0 xywh(3)],[y0 y0])];
  y0=y0-dxy(2);
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = hr_backhatch(xywh,xy0,dxy)
h=[];
xl=xywh(1);
xr=xywh(1)+xywh(3);
yb=xywh(2);
yt=xywh(2)+xywh(4);

x0=xy0(1);
y0=xy0(2);
while y0<=yb & x0<=xl
  x0=x0+dxy(1);
  y0=y0+dxy(2);
end
while y0<yt | x0<xr
  h=[h; hr_backplot([x0 y0],xywh,dxy)];
  x0=x0+dxy(1);
  y0=y0+dxy(2);
end

x0=xy0(1)-dxy(1);
y0=xy0(2)-dxy(2);
while y0>=yt & x0>=xr
  x0=x0-dxy(1);
  y0=y0-dxy(2);
end
while y0>yb | x0>xl
  h=[h;hr_backplot([x0 y0],xywh,dxy)];
  x0=x0-dxy(1);
  y0=y0-dxy(2);
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = hr_fwdhatch(xywh,xy0,dxy)
h=[];
xl=xywh(1);
xr=xywh(1)+xywh(3);
yb=xywh(2);
yt=xywh(2)+xywh(4);

x0=xy0(1);
y0=xy0(2);
while y0<=yb & x0>=xr
  x0=x0-dxy(1);
  y0=y0+dxy(2);
end
while y0<yt | x0>xl
  h=[h; hr_fwdplot([x0 y0],xywh,dxy)];
  x0=x0-dxy(1);
  y0=y0+dxy(2);
end

x0=xy0(1)+dxy(1);
y0=xy0(2)-dxy(2);
while y0>=yt & x0<=xl
  x0=x0+dxy(1);
  y0=y0-dxy(2);
end
while y0>yb | x0<xr
  h=[h;hr_fwdplot([x0 y0],xywh,dxy)];
  x0=x0+dxy(1);
  y0=y0-dxy(2);
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = hr_backplot(xy0,xywh,dxy)
yb = xy0(2)-(xywh(1)+xywh(3)-xy0(1))*dxy(2)/dxy(1);
if yb<xywh(2)
  xr = xy0(1)-(xywh(2)-xy0(2))*dxy(1)/dxy(2);
  yb = xywh(2);
else
  xr = xywh(1)+xywh(3);
end

yt = xy0(2)-(xywh(1)-xy0(1))*dxy(2)/dxy(1);
if yt>xywh(2)+xywh(4)
  xl = xy0(1)-(xywh(2)+xywh(4)-xy0(2))*dxy(1)/dxy(2);
  yt = xywh(2)+xywh(4);
else
  xl = xywh(1);
end
if xr<=xl
  h=[];
else
  h = plot([xl xr],[yt yb]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = hr_fwdplot(xy0,xywh,dxy)
yb = xy0(2)+(xywh(1)-xy0(1))*dxy(2)/dxy(1);
if yb<xywh(2)
  yb = xywh(2);
  xl = xy0(1)+(xywh(2)-xy0(2))*dxy(1)/dxy(2);
else
  xl = xywh(1);
end

yt = xy0(2)+(xywh(1)+xywh(3)-xy0(1))*dxy(2)/dxy(1);
if yt>xywh(2)+xywh(4)
  xr = xy0(1)+(xywh(2)+xywh(4)-xy0(2))*dxy(1)/dxy(2);
  yt = xywh(2)+xywh(4);
else
  xr = xywh(1)+xywh(3);
end
if xr<=xl
  h=[];
else
  h = plot([xl xr],[yb yt]);
end
