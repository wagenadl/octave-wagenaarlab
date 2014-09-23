function cc = ciexyztocielab(cc, whitepoint)
% CIEXYZTOCIELAB - Convert from CIE XYZ to CIE L*a*b* color space
%    cc = CIEXYZTOCIELAB(cc) converts from CIE XYZ to CIE L*a*b* color 
%    space. CC must be AxBx...x3 and have values in the range [0, 1].
%
%    Note: L*a*b* colors have unusual bounds: L* ranges from 0 to 100;
%    a* between -500 and +500; b* between -200 and +200.
%
%    By default, the D65 white point is used. (See WHITEPOINTS.)
%    This can be overridden: cc = CIEXYZTOCIELAB(cc, whitepoint). The 
%    white point may be given as an XYZ triplet or as one of several standard
%    names: d50, d55, d65, a, or c.

% The conversion here is based on 
% http://en.wikipedia.org/wiki/Lab_color_space
% White point information based on
% http://en.wikipedia.org/wiki/Illuminant_D65

if nargin<2 || isempty(whitepoint);
  whitepoint = 'd65';
end
if ischar(whitepoint)
  whitepoint = whitepoints(whitepoint);
end

[cc, S] = unshape(cc);

L0 = f(cc(:,2)./whitepoint(2));
Lstar = 116 * L0 - 16;
astar = 500 * (f(cc(:,1)./whitepoint(1)) - L0);
bstar = 200 * (L0 - f(cc(:,3)./whitepoint(3)));

cc = [Lstar astar bstar];
cc = reshape(cc, S);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = f(x)
big = x > (6/29)^3;
x(big) = x(big).^(1/3);
x(~big) = (1/3) * (29/6)^2 * x(~big) + (4/29);
