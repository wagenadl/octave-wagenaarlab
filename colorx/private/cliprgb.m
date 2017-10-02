function cc = cliprgb(cc, clip)
% CLIPRGB - Clip linear RGB colors (helper for ciexyztolinearrgb)

if clip==0
  ;
elseif clip==1
  cc(cc<0) = 0;
  cc(cc>1) = 1;
elseif isnan(clip)
  nn = any(cc<0 | cc>1, 2);
  cc(nn, :) = nan;
elseif clip==2
  cc(cc<0) = 0;
  mx = max(cc, [], 2);
  mx(mx<1) = 1;
  cc = cc ./ repmat(mx, [1 3]);
else
  error('Illegal clip specification');
end


