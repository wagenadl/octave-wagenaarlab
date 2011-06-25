function [h,a]=plotarc(x,y,dphi,clr,arperc,npts)
% PLOTARC - Plots an arc between two points
%    PLOTARC(x,y,dphi) plots an arc between (X(1),Y(1)) and (X(2),Y(2)),
%    deviating from the straight line by an initial angle DPHI (in radians).
%    PLOTARC(x,y,dphi,clr) specifies a color for the arc.
%    PLOTARC(x,y,dphi,clr,perc) also puts a little arrow head along the
%    arc at the given percentage away from the start (so PERC=67 places
%    the arrow head twice as far away from the start as from the end).
%    PLOTARC(x,y,dphi,clr,perc,npts) specifies how many points to interpolate
%    along the arc. Default is 20.
%    [h,a] = PLOTARC(...) returns handles for the curve and for the arrow
%    head.

if nargin<4 | isempty(clr)
  clr='k';
end
if nargin<5
  arperc=[];
end
if nargin<6 | isempty(npts)
  npts=20;
end

dy=diff(y);
dx=diff(x);
phi=atan2(dy,dx);
dr=sqrt(dy^2+dx^2)/2;
c1=[x(1)+dr*cos(phi+dphi) y(1)+dr*sin(phi+dphi)];
c2=[x(2)-dr*cos(phi-dphi) y(2)-dr*sin(phi-dphi)];
xy=bezier([x(1) y(1)],c1,c2,[x(2) y(2)],npts);
h=plot(xy(:,1),xy(:,2),'color',clr);
if ~isempty(arperc) | arperc==0
  ai=min(max(ceil(arperc*npts/100),2),npts);
  ai2=[ai-1 ai];
  a=arrowhead(xy(ai,1),xy(ai,2),...
      atan2(diff(xy(ai2,2)),diff(xy(ai2,1))),.06,.03,'solid');
  set(a,'facecolor',clr);
else
  a=[];
end

if nargout<2
  clear a
end
if nargout<1
  clear h
end
