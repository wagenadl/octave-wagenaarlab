function [omega,xy1] = elfind_nearest(el,xy)
% ELFIND_NEAREST   Find the nearest point on ellipse from a point in space
%   omega = ELFIND_NEAREST(el,xy) returns the parameter of the nearest point
%   on the ellipse EL from the point XY.
%   [omega,xy] = ELFIND_NEAREST(el,xy) also returns the coordinates of
%   the actual point.
%
%   Here, the ellipse is defined in radii and angle (XYRRA) form, i.e.:
%
%      |x|     |x0|   |cos(phi) -sin(phi)|  |xi |
%      | |  =  |  | + |                  |  |   | ,                    (1)
%      |y|     |y0|   |sin(phi)  cos(phi)|  |eta|
%
%    where:
%
%      |xi |    |R cos(omega)|
%      |   |  = |            | .                                       (2)
%      |eta|    |r sin(omega)|

% We have:
%
%    |xi |     | cos(phi)  sin(phi)|  |x-x0|
%    |   |  =  |                   |  |    | ,
%    |eta|     |-sin(phi)  cos(phi)|  |y-y0|
% 
% and must minimize:
%
%   D^2 = (xi - R cos(omega))^2 + (eta - R sin(omega))^2
% 
% w.r.t omega. That means:
%
%  (R^2-r^2) sin(omega) cos(omega) + r eta cos(omega) - R xi sin(omega) = 0.
% 
% Write this as
%
%  ((R^2-r^2) sin(omega) + r eta) cos(omega) = R xi sin(omega) ,
% 
% square left and right, and write cos^2(omega) = 1 - sin^2(omega):
%
%    2   2 2    2              2   2                      2        2                 2    2
% [(R - r )  sin (omega) + 2 (R - r ) sin(omega) + (r eta) ] [1-sin (omega)] - (R xi)  sin (omega) = 0.
%   
% This is a fourth order equation in sin(omega) which is easily solved.
% Then, I'll just use matlab's MIN function to find the nearest solution.

xy=xy(:)';
X = xy(1) - el.x0;
Y = xy(2) - el.y0;
xi = cos(el.phi)*X + sin(el.phi)*Y;
eta = -sin(el.phi)*X + cos(el.phi)*Y;

dR = el.R^2 - el.r^2;
if dR == 0
  sinomega = solvep2(...
      (el.r*eta)^2 + (el.R*xi)^2,...
      0,...
      -(el.r*eta)^2);
else
  sinomega = solvep4(...
      dR^2,...
      2*dR*el.r*eta,...
      (el.r*eta)^2 + (el.R*xi)^2 - dR^2,...
      -2*dR*el.r*eta,...
      -(el.r*eta)^2);
end
omega=asin(sinomega);
omega=[omega; pi-omega];

xi=el.R*cos(omega); 
eta=el.r*sin(omega);
xy1 = [el.x0 + cos(el.phi)*xi - sin(el.phi)*eta, ...
      el.y0 + sin(el.phi)*xi + cos(el.phi)*eta];

dd=sum(abs(repmat(xy,[length(omega) 1])-xy1).^2,2);
[dd,k]=min(dd);
omega=real(omega(k));

if nargout>1
  xy1=real(xy1(k,:));
else
  clear xy1
end

function d2 = elfn(omega,el,xi,eta)
cs=cos(omega);
sn=sin(omega);
d2 = (el.R*cos(omega)-xi).^2 + (el.r*sin(omega)-eta).^2;
