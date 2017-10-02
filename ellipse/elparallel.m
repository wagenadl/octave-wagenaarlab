function theta = elparallel(el,omega)
% ELPARALLEL  Find parallel to ellipse at a given point
%    theta = ELPARALLEL(el,omega) finds the angle of the parallel line to
%    the ellipse EL at its point OMEGA.
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

dxi = -el.R*sin(omega);
deta = el.r*cos(omega);
theta = atan2(deta,dxi) + el.phi;
