function [on,off] = bschmitt(xx, laststyle)
% BSCHMITT  Schmitt trigger of a binary process.
%   [on,off] = BSCHMITT(xx) is like a Schmitt trigger:
%   ON are the indices when XX becomes true from false.
%   OFF are the indices when XX becomes false from true.
%   If XX is high at the beginning, the first ON value will be 1.
%   By default, if XX is high at the end, the last upward crossing is ignored.
%   [on,off] = BSCHMITT(xx, 1) detects the last upward crossing,
%   making ON be 1 longer than OFF.
%   [on,off] = BSCHMITT(xx, 2) detects the last upward crossing,
%   making the last entry of OFF be length(XX)+1.
%   [on,off] = BSCHMITT(xx, 3) detects the last upward crossing,
%   making the last entry of OFF be +inf.

if nargin<2
  laststyle = 0;
end

lFALSE = logical(0);
lTRUE = logical(1);

xx=xx(:);
up = xx & ~[lFALSE; xx(1:end-1)];
dn = ~xx & [lTRUE;  xx(1:end-1)];
any = up|dn;
idx_any = find(any);

if isempty(idx_any)
  on=[];
  off=[];
  return;
end


typ_any = up(any);
use = [1; diff(typ_any)];

idx_use =idx_any(use~=0);
typ_use = typ_any(use~=0);

if ~isempty(typ_use)
  if typ_use(1)==0
    idx_use = idx_use(2:end);
    typ_use = typ_use(2:end);
  end
end

if laststyle==0
  if ~isempty(typ_use)
    if typ_use(end)==1
      idx_use = idx_use(1:end-1);
      typ_use = typ_use(1:end-1);
    end
  end
end

on = idx_use(typ_use==1);
off = idx_use(typ_use==0);

if laststyle>=2
  if length(off)<length(on)
    if laststyle==3
      off=[off;inf];
    else
      off=[off;length(xx)+1];
    end
  end
end
