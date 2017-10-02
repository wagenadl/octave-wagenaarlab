function [tt, yy, fs] = normalizespikedetargs(tt, yy)
% NORMALIZESPIKEDETARGS - Internal function to normalize argument order
%    [tt, yy] = NORMALIZESPIKEDETARGS(tt, yy) does nothing, but
%    [tt, yy] = NORMALIZESPIKEDETARGS(yy, tt) magically works too, as does
%    [tt, yy] = NORMALIZESPIKESDETARGS(yy, f_hz).
%    [tt, yy, fs] = NORMALIZESPIKESDETARGS(...) additionally returns sampling
%    rate.

if length(yy)==length(tt)
  if all(diff(yy)>0)
    [yy, tt] = id(tt, yy);
  elseif all(diff(tt)>0)
    % good
  else
    error('Cannot normalize arguments');    
  end
elseif isscalar(tt)
  fs = 1/tt;
  tt = [0:length(yy)-1]*fs;
elseif isscalar(yy)
  fs = 1/yy;
  yy = tt;
  tt = [0:length(yy)-1]*fs;
else
  error('Cannot normalize arguments');
end

tt = double(tt(:));
yy = double(yy(:));
fs = 1/mean(diff(tt));