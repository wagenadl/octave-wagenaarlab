function cc = ciexyztolinearrgb(cc, clip)
% CIEXYZTOLINEARRGB - Convert from CIE XYZ to linear RGB
%    cc = CIEXYZTOLINEARRGB(cc) converts from XYZ to linear RGB. CC must
%    be AxBx...x3 and have values in the range [0, 1].
%    Not all XYZ values are valid RGB. Those that would fall outside of 
%    the range get clipped to [0, 1]. This behavior can be refined:
%    cc = CIEXYZTOLINEARRGB(cc, clip) specifies a clip mode:
%      CLIP=0: no clipping (produces invalid rgb)
%      CLIP=1: hard clipping to [0, 1] (default)
%      CLIP=nan: set out of range values to NaN.
%      CLIP=2: hard clip at black, proportional clip at white.

if nargin<2 || isempty(clip)
  clip = 1;
end

[cc, S] = unshape(cc);

M = rgbxyz ^ -1;

cc = cc*M'; % That's the same as (M*cc')'

cc = cliprgb(cc, clip);
cc = reshape(cc, S);
