function cc = cieluvtociexyz(cc, whitepoint, clip)
% CIELUVTOCIEXYZ - Convert from CIE L*u*v to CIE XYZ color space
%    cc = CIELUVTOCIEXYZ(cc) converts from CIE L*u*v to CIE XYZ color space.
%    CC must be AxBx...x3 and have values in the range [0, 1].
%
%    Note: L*u*v* colors have unusual bounds: L* ranges from 0 to 100;
%    u* and b* "typicallay" between -100 and +100.
%
%    By default, the D65 white point is used. (See WHITEPOINTS.)
%    This can be overridden: cc = CIEXYZTOCIELUV(cc, whitepoint). The 
%    white point may be given as an XYZ triplet or as one of several standard
%    names: d50, d55, d65, a, or c.
%
%    This function can potentially lead to out-of-range XYZ values. By default,
%    these are left unclipped. cc = CIELUVTOCIEXYZ(..., clip) changes this
%    behavior:
%      CLIP=0: no clipping (default)
%      CLIP=1: hard clipping to [0, 1]
%      CLIP=nan: set out of range values to NaN.
%      CLIP=2: hard clip at black, proportional clip at white.

% Equations taken from http://en.wikipedia.org/wiki/CIELUV

if nargin<2 || isempty(whitepoint);
  whitepoint = 'd65';
end

if nargin<3
  clip = 0;
end

if ischar(whitepoint)
  whitepoint = whitepoints(whitepoint);
end

[cc, S] = unshape(cc);

nom = whitepoint(1) + 15*whitepoint(2) + 3*whitepoint(3);
upn = 4*whitepoint(1) / nom;
vpn = 9*whitepoint(2) / nom;

up = cc(:,2) ./ (13*cc(:,1)) + upn;
vp = cc(:,3) ./ (13*cc(:,1)) + vpn;
big = cc(:,1) > 8;
cc(big, 2) = whitepoint(2) * ((cc(big, 1)+16)/116).^3;
cc(~big, 2) = whitepoint(2) * cc(~big, 1) .* (3/29).^3;
cc(:,1) = cc(:,2) .* (9*up)./(4*vp);
cc(:,3) = cc(:,2) .* (12 - 3*up - 20*vp) ./ (4*vp);

cc = clipxyz(cc, clip);
cc = reshape(cc, S);
