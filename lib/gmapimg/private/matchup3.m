function [idx, revidx, merit] = matchup3(actual, canon, S, WR)
% basic matching
if nargin<3
  S = .5;
end
if nargin<4
  WR = 40;
end

if isempty(actual.x) || isempty(canon.x)
  idx = [];
  revidx = [];
  merit = 0;
  return;
end

actual.r *= sqrt(WR);
canon.r *= sqrt(WR);

[idx, scr] = matchupx_core([actual.x(:), actual.y(:), actual.r(:)]', ...
    [canon.x(:), canon.y(:), canon.r(:)]', ...
    S);
idx = idx + 1;

R = length(actual.x);
revidx=zeros(R, 1);
use = find(idx>0);
revidx(idx(use)) = use;
merit = sum(scr);
