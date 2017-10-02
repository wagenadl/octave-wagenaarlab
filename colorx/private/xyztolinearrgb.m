function cc = xyztolinearrgb(cc, clip)
% XYZTOLINEARRGB - Convert from CIE XYZ to linear RGB
%    cc = XYZTOLINEARRGB(cc) converts from XYZ to linear RGB. CC must
%    be AxBx...x3 and have values in the range [0, 1].
%    Not all XYZ values are valid RGB. Those that would fall outside of 
%    the range get clipped to [0, 1]. This behavior can be refined:
%    cc = XYZTOLINEARRGB(cc, clip) specifies a clip mode:
%      CLIP=0: no clipping (produces invalid rgb)
%      CLIP=1: hard clipping to [0, 1]
%      CLIP=nan: set out of range values to NaN.
%      CLIP=2: hard clip at black, proportional clip at white.

% The conversion here is based on http://en.wikipedia.org/wiki/SRGB

if nargin<2 || isempty(clip)
  clip = 1;
end

[cc, S] = unshape(cc);

M =  [ 3.240625  -1.537208  -0.498629; ...
  -0.968931   1.875756   0.041518; ...
  0.055710  -0.204021   1.056996 ];

cc = cc*M'; % That's the same as (M*cc')'

if clip==0
  ;
elseif clip==1
  cc(cc<0) = 0;
  cc(cc>1) = 1;
elseif isnan(clip)
  cc(cc<0 | cc>1) = nan;
elseif clip==2
  cc(cc<0) = 0;
  mx = max(cc, [], 3);
  mx(mx<1) = 1;
  cc = cc ./ repmat(mx, [1 3]);
else
  error('Illegal clip specification');
end

cc = reshape(cc, S);
