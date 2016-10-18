function bst = findgears(tpi, allow)
% FINDGEARS - Find best gear combo for given TPI thread
%    FINDGEARS(tpi) reports the best gear combo for that TPI thread
%    FINDGEARS(tpi, 1) allows for changing gears from 32/48.
%    FINDGEARS(tpi, 2) also allows for using the metric conversion gear
%    nearesttpi = FINDGEARS(tpi) returns the nearest tpi available.
%    25.4/FINDGEARS(25.4/mm, 2) is useful for finding the closest available
%    mm thread.
%    When multiple combinations are possible, all are given. The official
%    chart appears to prefer number 4.


if nargin<2
  allow = 0;
end

tri = [0; 1];
sq = [0 1];
num = reshape([1 2 3 4 5 6],[1 1 6]);
let = reshape([1 2 3 4 5],[1 1 1 5]);
if allow
  gear1=reshape([32 44 48],[1 1 1 1 3]);
  gear2=reshape([33 46 48 52],[1 1 1 1 1 4]);
else
  gear1 = 32;
  gear2 = 48;
end

tpis = gearcalc(tri, sq, num, let, gear1, gear2);

[bst, idx] = min(abs(tpis(:) - tpi));
idx = find(abs(tpis(:)-tpi) <= bst);
mm = 0;
fac = 1;
if allow>1
  [bst1, idx1] = min(abs(127/120*tpis(:) - tpi));
  if bst1<bst
    idx = find(abs(127/120*tpis(:)-tpi) <= bst1);
    mm = 1;
    fac = 127/120;
  end
end

for id = idx'
  bst = fg_report(tpi, tpis, id, allow, mm, fac, gear1, gear2);
end

if nargout<1
  clear bst
end

function bst = fg_report(tpi, tpis, idx, allow, mm, fac, gear1, gear2);
[t, s, n, l, g1, g2] = ind2sub(size(tpis), idx);

if t>1
  tr = '△';
else
  tr = '○';
end
if s>1
  sq = '□';
else
  sq = '⬠';
end
lt = 'A' + l-1;

if mm
  tpis = tpis*fac;
end
delta = tpis(idx) - tpi;

if mm
  if delta==0
    printf('Perfect for %g is %s  %s  %i %c (at %i/%i with 120/127)\n',
    	tpi, ...
	tr, sq, n, lt, ...
	gear1(g1), gear2(g2));
  else
    printf('Best for %g is %s  %s  %i %c (at %i/%i with 120/127): %g (Δ = %g)\n', ...
	tpi, ...
	tr, sq, n, lt, ...
	gear1(g1), gear2(g2), ...
	tpis(idx), tpis(idx)-tpi);
  end
else
  if delta==0
    printf('Perfect for %g is %s  %s  %i %c (at %i/%i)\n', ...
	tpi, ...
	tr, sq, n, lt, ...
	gear1(g1), gear2(g2));
  else    
    printf('Best for %g is %s  %s  %i %c (at %i/%i): %g (Δ = %g)\n', ...
	tpi, ...
	tr, sq, n, lt, ...
	gear1(g1), gear2(g2), ...
	tpis(idx), tpis(idx)-tpi);
  end
end

bst = tpis(idx);