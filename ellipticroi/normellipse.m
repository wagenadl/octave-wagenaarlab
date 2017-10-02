function xyrra = normellipse(xyxy)
% NORMELLIPSE - Convert xyxy ellipses to xyrra ellipses
%    xyrra = NORMELLIPSE(xyxy) converts a set of ellipses defined by 
%    4-vectors to the new style defined by 5-vectors.
%    xyrra = NORMELLIPSE(xyrra) does nothing.
%    Note: If XYXY (or XYRRA) is 1xX, it is changed to Xx1 before any
%    conversions.
%    The old style was [x_left y_top x_right y_bot].
%    The new style is [x_center y_center r_major r_minor phi_rad].
[X N] = size(xyxy);
if X==1
  xyxy=xyxy';
  [X N] = size(xyxy);
end

if X==4
  xyrra = [mean(xyxy([1 3],:)); mean(xyxy([2 4],:)); ...
    abs(diff(xyxy([1 3],:)))/2; abs(diff(xyxy([2 4],:)))/2; ...
    zeros(1,N)];
elseif X==5
  xyrra = xyxy;
elseif isempty(xyxy)
  xyrra=xyxy;
else
  error('Normellipse: ellipses must be defined by a 4- or 5-vector.');
end
