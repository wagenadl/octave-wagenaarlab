function trc = tracer_addlens(trc, f_mm, x)
% TRACER_ADDIDEALLENS - Adds an idealized lens to a tracer object
%    trc = TRACER_ADDLENS(trc, f_mm, x) adds an ideal lens with focal
%    length F_MM at location X along the optical axis.

trc.lenses{end+1} = f_mm;
trc.xlens(end+1) = x;
trc.flip(end+1) = 0; % irrelevant
trc.align(end+1) = 0; % irrelevant
trc.placed = 0;
