function el = eldrag_rotate(el,whence,npts,varargin)
% ELDRAG_ROTATE   Lets the user drag a point on ellipse around
%    el = ELDRAG_ROTATE(el,whence) lets the user drag a point on the given 
%    ellipse around in the current axes, and finally returns the new shape.
%    If WHENCE=0, rotation is about center; otherwise it is about far point.
%    el = ELDRAG_ROTATE(el,whence,npts) specifies number of points to draw.
%    el = ELDRAG_ROTATE(el,whence,npts,key1,val1,...) specifies additional
%    plot parameters.

if getappdata(gcf,'mousemove__recurse')
  return
end

hld=ishold;
hold on
setappdata(gca,'eldrag_h',[]);
xy = get(gca,'currentpoint'); xy=xy(1,1:2);

omega = elfind_nearest(el,xy);
[xy0,xy1] = mousemove(@eldr_move, el, whence, omega, npts, varargin{:});

if getappdata(gca,'mousemove_significant')
  el = eldr_recalc(el,whence,omega,xy1-xy0);
end

delete(getappdata(gca,'eldrag_h'));
setappdata(gca,'eldrag_h',[]);
if ~hld
  hold off
end


function eldr_move(h, xy0, xy1, el, whence, omega, npts, varargin)
if getappdata(h,'mousemove_significant')
  delete(getappdata(h,'eldrag_h'));
  p=elplot_xyrra(eldr_recalc(el,whence,omega,xy1-xy0),npts,varargin{:});
  setappdata(h,'eldrag_h',p);
end


function el = eldr_recalc(el,whence,omega,dxy)
xi = el.R*cos(omega);
eta = el.r*sin(omega);
cs=cos(el.phi); sn=sin(el.phi);

x = cs*xi-sn*eta; % This is the point I am dragging
y = sn*xi+cs*eta;

if whence
  % Rotate w.r.t far point; convert to alternative coordinates
  x=2*x;
  y=2*y;
  theta0 = atan2(y,x);
  theta1 = atan2(y+dxy(2),x+dxy(1));
  dphi = theta1-theta0;
  el.phi = el.phi + dphi;
  x1=x*cos(dphi)-y*sin(dphi);
  y1=x*sin(dphi)+y*cos(dphi);
  el.x0=el.x0-x/2+x1/2;
  el.y0=el.y0-y/2+y1/2;
else
  theta0 = atan2(y,x);
  theta1 = atan2(y+dxy(2),x+dxy(1));
  el.phi = el.phi + theta1-theta0;
end

  