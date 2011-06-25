function el_ = ELRRA2ABC(el)
% ELRRA2ABC   Convert between ellipse representations
%    el = ELRRA2ABC converts from radii, angle representation to covariance
%    representation.
%
%    In radii, angle representation, an ellipse is defined by a curve:
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
%
%    In covariance representation, an ellipse is defined by an equation:
%
%                  2              2
%      alpha (x-x0)  + beta (y-y0)  + 2 gamma (x-x0)(y-y0) = 1.        (3)
%
%    This function converts from the first to the second form.

% From (2), we have: xi^2/R^2 + eta^2/r^2 = 1.                         (4)
%
% Defining X:=x-x0, Y:=y-y0, we invert (1) to get
%
%   |xi |    | cos(phi)  sin(phi)|  |X|
%   |   |  = |                   |  | | ,                              (5)
%   |eta|    |-sin(phi)  cos(phi)|  |Y|
%
% Inserting (5) in (4), gives
%
%   (cs*X+sn*Y)^2/R^2 + (cs*Y-sn*X)^2/r^2 = 1,
%
% where cs:=cos(phi) and sn:=sin(phi).
%
% Expand:
%
%   (cs^2/R^2 + sn^2/r^2) X^2 + (sn^2/R^2 + cs^2/r^2) Y^2 +
%     + 2*(cs*sn/R^2 - cs*sn/r^2) XY = 1.
%
% Result: alpha = cs^2/R^2 + sn^2/r^2
%         beta  = sn^2/R^2 + cs^2/r^2
%         gamma = cs*sn*(1/R^2-1/r^2).

el_.x0=el.x0;
el_.y0=el.y0;
cs = cos(el.phi);
sn = sin(el.phi);
el_.alpha = cs^2/el.R^2 + sn^2/el.r^2;
el_.beta  = sn^2/el.R^2 + cs^2/el.r^2;
el_.gamma = cs*sn*(1/el.R^2 - 1/el.r^2);
