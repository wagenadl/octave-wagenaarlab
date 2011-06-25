function el = eldrag_resize(el,npts,varargin)
% ELDRAG_RESIZE   Lets the user drag a point on ellipse around
%    el = ELDRAG_RESIZE(el) lets the user drag a point on the given 
%    ellipse around in the current axes, and finally returns the new shape.
%    el = ELDRAG_RESIZE(el,npts) specifies number of points to draw.
%    el = ELDRAG_RESIZE(el,npts,key1,val1,...) specifies additional
%    plot parameters.

if getappdata(gcf,'mousemove__recurse')
  return
end

hld=ishold;
hold on
setappdata(gca,'eldrag_h',[]);
xy = get(gca,'currentpoint'); xy=xy(1,1:2);

omega = elfind_nearest(el,xy);
theta = elparallel(el,omega) - pi/2;

[xy0,xy1] = mousemove(@eldr_move,el,theta,omega,npts,varargin{:});

if getappdata(gca,'mousemove_significant')
  el = eldr_recalc(el,omega,theta,xy1-xy0);
end

delete(getappdata(gca,'eldrag_h'));
setappdata(gca,'eldrag_h',[]);
if ~hld
  hold off
end


function eldr_move(h, xy0, xy1, el, theta, omega, npts, varargin)
if getappdata(h,'mousemove_significant')
  delete(getappdata(h,'eldrag_h'));
  p=elplot_xyrra(eldr_recalc(el,omega,theta,xy1-xy0),npts,varargin{:});
  setappdata(h,'eldrag_h',p);
end


function el = eldr_recalc(el,omega,theta,dxy)
% Rotate to coord. sys. where near point is on far right of ellipse:
el.phi = el.phi - theta;
dXY = [cos(theta)*dxy(1)+sin(theta)*dxy(2), ...
      -sin(theta)*dxy(1)+cos(theta)*dxy(2)];

% NB: el.x0, el.y0 have NOT been rotated

% Find height (in rotated coord sys)
[om,mxy] = elmaxy(el);
H = mxy-el.y0;

% Find moving point, relative to center of ellipse
xi=el.R*cos(omega); eta=el.r*sin(omega);
X=cos(el.phi)*xi-sin(el.phi)*eta;
Y=sin(el.phi)*xi+cos(el.phi)*eta;

% Move the point
X=X+dXY(1)/2; % NB: Will later move x0,y0 some too.
Y=Y+dXY(2)/2; % NB: Will later move x0,y0 some too.
H=H+dXY(2)/2;

% Define a new ellipse based on maxy=H0, maxx=X, y(maxx)=Y.
% This is easiest in variance coordinates:
%
%   alpha x^2 + beta y^2 + 2 gamma x y = 1.
%
% That means:
%                                                       2   2
%         - gamma x  +-  sqrt(beta - (alpha beta - gamma ) x ) 
%   y = ------------------------------------------------------- .
%                                   beta                     
%
% and:
%                                                        2   2
%         - gamma y  +-  sqrt(alpha - (alpha beta - gamma ) y )
%   x = ------------------------------------------------------- .
%                                   alpha                      

% Extreme y: H^2 = alpha / (alpha beta - gamma^2).  (1)
%
% Extreme x: X^2 = beta / (alpha beta - gamma^2).   (2)
%
% At extreme x: Y = - gamma X / beta.               (3)
%
% Solve (3): gamma = -Y/X  beta.
%
% Insert (1) in (2): alpha/H^2 = beta/X^2, or alpha = H^2/X^2 beta
%
% Rewrite (2): X^2 (alpha beta - gamma^2) = beta.
%
% Insert eqns for alpha and gamma:
%
%  X^2 beta^2 (H^2/X^2 - Y^2/X^2) = beta.
%
% Solve: beta = 1/(H^2-Y^2).

if H<-Y
  H=-Y + abs(H+Y);
end

EL.beta = 1/(H^2-Y^2);
EL.alpha = H^2/X^2 * EL.beta;
EL.gamma = -Y/X * EL.beta;
EL.x0=0; EL.y0=0; % Dummy

% Convert back to radii:
EL = elabc2rra(EL);
el.R=EL.R;
el.r=EL.r;
el.phi=EL.phi+theta; % Unrotate
el.x0=el.x0+dxy(1)/2;
el.y0=el.y0+dxy(2)/2;