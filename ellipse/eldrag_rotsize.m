function el = eldrag_rotsize(el,npts,varargin)
% ELDRAG_ROTSIZE   Lets the user drag a point on ellipse around
%    el = ELDRAG_ROTSIZE(el) lets the user drag a point on the given 
%    ellipse around in the current axes, and finally returns the new shape.
%    el = ELDRAG_ROTSIZE(el,npts) specifies number of points to draw.
%    el = ELDRAG_ROTSIZE(el,npts,key1,val1,...) specifies additional
%    plot parameters.

if getappdata(gcf,'mousemove__recurse')
  return
end

h=gca;
hld=ishold;
hold on
xy = get(h,'currentpoint'); xy=xy(1,1:2);

omega = elfind_nearest(el,xy);
theta = elparallel(el,omega) - pi/2;

setappdata(h,'eldrag_h',[]);
[xy0,xy1] = mousemove(@eldr_move,el,theta,omega,npts,varargin{:});
delete(getappdata(h,'eldrag_h'));
setappdata(h,'eldrag_h',[]);

if getappdata(h,'mousemove_significant')
  el = eldr_recalc(el,omega,theta,xy1-xy0);
end

axes(h);
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

% Find old angle and new angle of this point, and change in radius
theta0 = atan2(Y,X);
theta1 = atan2(2*Y+dXY(2),2*X+dXY(1));
dphi = theta1-theta0;
dR = sqrt((2*X+dXY(1))^2+(2*Y+dXY(2))^2) - sqrt((2*X)^2+(2*Y)^2);

% Now, first do the rotation part of the transformation (back in base coords)
el.phi = el.phi + theta;

% Find moving point again, relative to center of ellipse, now in base coords.
xi=el.R*cos(omega); eta=el.r*sin(omega);
x=cos(el.phi)*xi-sin(el.phi)*eta;
y=sin(el.phi)*xi+cos(el.phi)*eta;
x1=x*cos(dphi)-y*sin(dphi);
y1=x*sin(dphi)+y*cos(dphi);
el.phi = el.phi + dphi;
el.x0=el.x0-x+x1;
el.y0=el.y0-y+y1;

% OK, now we are rotated, let's do the rescaling part
% Once again, move our point to far right
el.phi = el.phi - (theta + dphi);

% Move the point
X=X+dR/2; % NB: Will later move x0,y0 some too.

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
el.phi=EL.phi + (theta+dphi); % Unrotate

el.x0=el.x0+dR/2*cos(theta+dphi);
el.y0=el.y0+dR/2*sin(theta+dphi);

