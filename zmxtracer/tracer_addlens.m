function trc = tracer_addlens(trc, lens, x, rev, align)
% TRACER_ADDLENS - Adds a lens to a tracer object at a given location
%    trc = TRACER_ADDLENS(trc, lens, x) adds the LENS at location X along
%    the optical axis.
%    trc = TRACER_ADDLENS(trc, lens, x, 1) places the lens backwards.
%    trc = TRACER_ADDLENS(trc, lens, x, orient, align) specifies 
%    alignment:
%      ALIGN = 0: align on middle of lens (default)
%              1: align on first principal plane
%              2: align on second principal plane
%              3: align on first surface
%              4: align on last surface

trc.lenses{end+1} = lens;
trc.xlens(end+1) = x;
if nargin>=4 && rev
  trc.flip(end+1) = 1;
else
  trc.flip(end+1) = 0;
end
if nargin<5
  align = 0;
end
trc.align(end+1) = align;
trc.placed = 0;
