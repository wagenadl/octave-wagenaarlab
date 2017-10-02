function cc = applylut(xx, lut, clim, nanc)
% APPLYLUT - Apply a color lookup table
%   cc = APPLYLUT(xx, lut, clim) applies the lookup table LUT to the data XX
%   and returns the resulting colors. XX may be any shape, LUT must be Nx3.
%   CLIM specifies colormap limits; if not given, min/max of XX are used.
%   cc = APPLYLUT(xx, lut, clim, nanc) specifies a separate color for NaNs in 
%   XX. NANC must be 1x3.

S = size(xx);

xx = xx(:);

if nargin<3
  clim=[min(xx) max(xx)];
end
if nargin<4
  nanc=lut(1,:);
end

C = size(lut,1);

cc = ceil((xx-clim(1))/(clim(2)-clim(1)) * C);
cc(cc<1) = 1;
cc(cc>C) = C;
cc(isnan(cc)) = 1; % for now

cc = lut(cc,:);
idx = find(isnan(xx));
cc(idx,:) = repmat(nanc, [length(idx) 1]);

while length(S)>1 & S(end)==1
  S = S(1:end-1);
end

cc = reshape(cc, [S 3]);
