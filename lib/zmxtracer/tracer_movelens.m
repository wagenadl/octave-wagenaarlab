function trc = tracer_movelens(trc, lensno, x)
% TRACER_MOVELENS - Move a previously placed lens to a new location
%    trc = TRACER_MOVELENS(trc, lensno, x) moves the lens identified by
%    LENSNO (counting from 1 in order of TRACER_ADDLENS calls) and moves
%    it to new location X. Orientation and alignment options are not changed.

trc.xlens(lensno) = x;
trc.placed = 0;

