function [x0,y0,c,a] = fitcup(z)
% FITCUP - Fits a cup shape to 2D data
%    [x0,y0,c,a] = FITCUP(z), where z = (2R+1) x (2R+1), fits
%
%      z = a + c/2 (x-x0)^2 + c/2 (y-y0)^2.

% We start by writing
%
%      z = A + bx + dy + c/2 x^2 + c/2 y^2.
%
% Then, since sum(x) = sum(x^3) = 0, we get:
%
% dChi/dA = 0 <=> A sum(1) + c/2 sum(x^2+y^2) = sum(z)
% dChi/db = 0 <=> b sum(x^2) = sum(xz)
% dChi/dd = 0 <=> d sum(y^2) = sum(yz)
% dChi/dc = 0 <=> A sum(x^2+y^2) + c/2 sum((x^2+y^2)^2) = sum((x^2+y^2)*z)
%
% Finally, we equate
%
%   a + c/2 (x-x0)^2 + c/2 (y-y0)^2 = A + bx + dy + c/2 x^2 + c/2 y^2 
%
% for all x, y. Thus this must hold for terms:
%
%   1: a + c/2 x0^2 + c/2 y0^2 = A
%   x: -c x0 = b
%   y: -c y0 = d
%   x^2: c = c
%   y^2: c = c
%   xy: 0 = 0

[Y X]=size(z);
rY=(Y-1)/2;
rX=(X-1)/2;
x=repmat([-rX:rX],[Y 1]);
y=repmat([-rY:rY]',[1 X]);

b = sum(sum(x.*z)) ./ sum(sum(x.^2));
d = sum(sum(y.*z)) ./ sum(sum(y.^2));

a1=X*Y;
c1=sum(sum(x.^2+y.^2)/2);
z1=sum(sum(z));
a2=sum(sum(x.^2+y.^2));
c2=sum(sum((x.^2+y.^2).^2/2));
z2=sum(sum((x.^2+y.^2).*z));

c = (z1*a2-z2*a1)/(c1*a2-c2*a1);

x0 = -b/c;
y0 = -d/c;

if nargout<3
  clear c
end
if nargout>=4
  A = -(z1*c2-z2*c1)/(c1*a2-c2*a1);
  a = A - c*x0^2/2 - c*y0^2/2;
end
