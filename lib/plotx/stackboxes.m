function yy = stackboxes(xxl, xxr)
% STACKBOXES - Make a compact stack of rectangular boxes
%    yy = STACKBOXES(xxl, xxr) organizes the N boxes defined by left edges
%    at XXL (Nx1) and right edges at XXR (Nx1) such that all boxes are at
%    or above YY=1, the leftmost box is at YY=1, no boxes overlap, and the
%    pile of boxes is not overly tall.
%    STACKBOXES uses a greedy algorithm and it is possible that some cases
%    are not solved optimally.

xxl = xxl(:);
xxr = xxr(:);

N = length(xxl);
if length(xxr)~=N
  error('Left and right edges must pair up');
end

[~,ord] = sort(xxl);

xfory = zeros(N,1) + xxl(ord(1));

yy = zeros(N,1);

for k=1:N
  n = ord(k);
  y = find(xfory <= xxl(n), 1);
  yy(n) = y;
  xfory(y) = xxr(n);
end
