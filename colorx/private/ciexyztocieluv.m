function cc = ciexyztocieluv(cc, whitepoint)
% CIEXYZTOCIELUV - Convert from CIE XYZ to CIE L*u*v* color space
%    cc = CIEXYZTOCIELUV(cc) converts from CIE XYZ to CIE L*u*v* color 
%    space. CC must be AxBx...x3 and have values in the range [0, 1].
%
%    Note: L*u*v* colors have unusual bounds: L* ranges from 0 to 100;
%    u* and v* "typically" between -100 and +100.
%
%    By default, the D65 white point is used. (See WHITEPOINTS.)
%    This can be overridden: cc = CIEXYZTOCIELUV(cc, whitepoint). The 
%    white point may be given as an XYZ triplet or as one of several standard
%    names: d50, d55, d65, a, or c.

% Equations taken from http://en.wikipedia.org/wiki/CIELUV

if nargin<2 || isempty(whitepoint);
  whitepoint = 'd65';
end
if ischar(whitepoint)
  whitepoint = whitepoints(whitepoint);
end

[cc, S] = unshape(cc);

nom = whitepoint(1) + 15*whitepoint(2) + 3*whitepoint(3);
upn = 4*whitepoint(1) / nom;
vpn = 9*whitepoint(2) / nom;

nom = cc(:,1) + 15*cc(:,2) + 3*cc(:,3);
up =  4*cc(:,1) ./ nom;
vp =  9*cc(:,2) ./ nom;
big = (cc(:,2)/whitepoint(2)) > (6/29)^3;
cc(big, 1) = 116*(cc(big,2)/whitepoint(2)).^(1/3) - 16;
cc(~big, 1) = (29/3)*(cc(~big,2)/whitepoint(2));
cc(:,2) = 13*cc(:,1) .*(up - upn);
cc(:,3) = 13*cc(:,1) .*(vp - vpn);

cc = reshape(cc, S);
