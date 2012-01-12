function h = logicplot(xx, yy, varargin)
% LOGICPLOT - Plot logic signals with vertical edges
%   LOGICPLOT(xx, yy) plots the given data as a logic signal, with vertical
%   state transitions.
%   LOGICPLOT(xx, yy, k, v, ...) specifies additional arguments for PLOT.
%   h = LOGICPLOT(...) returns a plot handle.
%   YY doesn't have to be zeros and ones. For instance:
%
%     xx = [0:.001:2*pi];
%     yy = abs(cos(xx)) > .5;
%     logicplot(xx, 5*yy + 10);
% 
%   This plots "logical zero" at y=10, and "logical one" at y=15.

avg = mean(yy);
l0 = mean(yy(yy<avg));
l1 = mean(yy(yy>avg));
N = length(yy);
[up,dn] = schmitt(yy, (avg+l1)/2, (avg+l0)/2, 2);

xxx = xx(1);
yyy = l0;
for k=1:length(up)
  if up(k)==1
    yyy(end) = l1;
  else
    xxx(end+1) = xx(up(k));
    yyy(end+1) = l0;
  end
  xxx(end+1) = xx(up(k));
  yyy(end+1) = l1;
  xxx(end+1) = xx(dn(k)-1);
  yyy(end+1) = l1;
  if dn(k)<=N
    xxx(end+1) = xx(dn(k)-1);
    yyy(end+1) = l0;
  end
end
if dn(end)<=N
  xxx(end+1) = xx(end);
  yyy(end+1) = l0;
end

h = plot(xxx,yyy,varargin{:});

    