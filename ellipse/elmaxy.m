function [omega, ymax, ymin] = elmaxy(el)
% ELMAXY   Find the largest y-value for an ellipse
%    omega = ELMAXY(el) finds the parameter corresponding to the 
%    largest y-value for an ellipse.
%    [omega, ymax] = ELMAXY(el) also returns the y-value.
%    [omega, ymax, ymin] = ELMAXY(el) also returns the minimal y-value.
%
%   Here, the ellipse is defined in XYRRA form, i.e.:
%
%      |x|     |x0|   |cos(phi) -sin(phi)|  |xi |
%      | |  =  |  | + |                  |  |   | ,
%      |y|     |y0|   |sin(phi)  cos(phi)|  |eta|
%
%    where:
%
%      |xi |    |R cos(omega)|
%      |   |  = |            | .
%      |eta|    |r sin(omega)|

% Thus: y = y0 + R sin(phi) cos(omega) + r cos(phi) sin(omega).
%
% dy/domega = 0
%
% <=> - R sin(phi) sin(omega) + r cos(phi) cos(omega) = 0
%
%      sin(omega)     r cos(phi)
% <=> ------------ = ------------
%      cos(omega)     R sin(phi)

omega = atan2(el.r*cos(el.phi), el.R*sin(el.phi));

omega=[omega omega+pi]; % One is max, other is min.

y = el.y0 + el.R*sin(el.phi)*cos(omega) + el.r*cos(el.phi)*sin(omega);
[ymax,id] = max(y);
omega=omega(id);
if nargout<2
  clear ymax
elseif nargout>=3
  ymin=min(y);
end
