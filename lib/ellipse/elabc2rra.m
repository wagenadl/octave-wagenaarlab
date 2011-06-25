function el_ = ELABC2RRA(el)
% ELABC2RRA   Convert between ellipse representations
%    el = ELABC2RRA converts from covariance representation to radii, angle 
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
%    This function converts from the second to the first form.

% Let X:=x-x0, Y:=y-y0, cs:=cos(phi), sn:=sin(phi), and insert (1) in (3):
%
%   alpha (cs*xi - sn*eta)^2  +  beta (sn*xi + cs*eta)^2  +
%     +  2 gamma (cs*xi - sn*eta) (sn*xi + cs*eta)  =  1.
%
% Expand:
%
%   (alpha cs^2 + beta sn^2 + 2 gamma cs*sn) xi^2  +
%     +  (alpha sn^2 + beta cs^2 - 2 gamma cs*sn) eta^2  +
%     +  2 (-alpha cs*sn + beta cs*sn + gamma (cs^2-sn^2)) xi eta =  1.
%
% Thus, R = 1/sqrt(alpha cs^2 + beta sn^2 + 2 gamma cs*sn),            (4)
%       r = 1/sqrt(alpha sn^2 + beta cs^2 - 2 gamma cs*sn),            (5)
%   and (-alpha cs*sn + beta cs*sn + gamma (cs^2-sn^2)) = 0.           (6)
%
% Recall that 2 cos(x) sin(x) = sin(2*x), and cos^2(x) - sin^2(x) = cos(2*x).
%
% Inserting into (6) gives:
%
%   (alpha-beta) sin(2phi) = 2 gamma cos(2phi),
% 
% i.e.
%                    2 gamma
%   tan(2phi)  =  --------------
%                  alpha - beta

el_.x0 = el.x0;
el_.y0 = el.y0;
el_.phi = 0.5 * atan2(2*el.gamma, el.alpha-el.beta);

cs=cos(el_.phi);
sn=sin(el_.phi);

el_.R = 1/sqrt(el.alpha*cs^2 + el.beta*sn^2 + 2*el.gamma*cs*sn);
el_.r = 1/sqrt(el.alpha*sn^2 + el.beta*cs^2 - 2*el.gamma*cs*sn);

if el_.R < el_.r
  [el_.r, el_.R] = swap(el_.r, el_.R);
  el_.phi = el_.phi + pi/2;
  if el_.phi >= pi
    el_.phi = el_.phi - 2*pi;
  end
end
