function yy = tracer_yatx(trc, x)
% TRACER_YATX - Return y-positions of output rays at a given x-position
%   yy = TRACER_YATX(trc, x) returns the y-positions of all the output
%   rays at the given x-position along the optical axis.
%
%   See also TRACER_IMAGEX.

yy = trc.y1 + x*trc.tantheta1;
