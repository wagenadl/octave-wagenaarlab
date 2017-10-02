function cc = cielabtociexyz(cc, whitepoint, clip)
% CIELABTOCIEXYZ - Convert CIE L*a*b* colors to CIE XYZ
%    cc = CIELABTOCIEXYZ(cc) converts from CIE L*a*b* to CIE XYZ color
%    space. CC must be AxBx...x3.
%
%    Note: L*a*b* colors have unusual bounds: L* ranges from 0 to 100;
%    a* between -500 and +500; b* between -200 and +200.
%
%    By default, the D65 white point is used. (See WHITEPOINTS.)
%    This can be overridden: cc = CIELABTOCIEXYZ(cc, whitepoint). The 
%    white point may be given as an XYZ triplet or as one of several standard
%    names: d50, d55, d65, a, or c.
%
%    This function can potentially lead to out-of-range XYZ values. By default,
%    these are left unclipped. cc = CIELABTOCIEXYZ(..., clip) changes this
%    behavior:
%      CLIP=0: no clipping (default)
%      CLIP=1: hard clipping to [0, 1]
%      CLIP=nan: set out of range values to NaN.
%      CLIP=2: hard clip at black, proportional clip at white.

% The conversion here is based on 
% http://en.wikipedia.org/wiki/Lab_color_space
% White point information based on
% http://en.wikipedia.org/wiki/Illuminant_D65

if nargin<2 || isempty(whitepoint)
  whitepoint = 'd65';
end

if nargin<3
  clip = 0;
end

if ischar(whitepoint)
  whitepoint = whitepoints(whitepoint);
end

[cc, S] = unshape(cc);

L0 = (1/116) * (cc(:,1) + 16);
Y = whitepoint(2) * finv(L0);
X = whitepoint(1) * finv(L0 + cc(:,2)/500);
Z = whitepoint(3) * finv(L0 - cc(:,3)/200);

cc = [X Y Z];

cc = clipxyz(cc, clip);
cc = reshape(cc, S);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = finv(x)
big = x > 6/29;
x(big) = x(big).^3;
x(~big) = 3 * (6/29)^2 * (x(~big) - (4/29));
