function trc = tracer_placelenses(trc, wl)
% TRACER_PLACELENSES - Fine position the lenses for subsequent tracing
%    trc = TRACER_PLACELENSES(trc, lambda) prepares the tracer object TRC 
%    for subsequent tracing by instantiating lens placement. This step is
%    optional; if left out, it will happen automatically at first trace.
%    For lenses placed at their principal planes, this will calculate
%    where those principal planes are for the given wavelength LAMBDA.

if nargin<2
  wl = 532;
end

trc.x_surf = [];
trc.r_surf = [];
trc.dn_surf = [];
for k=1:length(trc.lenses)
  [xx_, rr_, fn_] = tracer_lens2surf(trc.lenses{k}, trc.flip(k), ...
      trc.align(k), wl);
  xx_ = xx_ + trc.xlens(k);
  nn_ = tracer_applyfn(fn_, wl);
  trc.x_surf = [trc.x_surf; xx_(:)];
  trc.r_surf = [trc.r_surf; rr_(:)];
  trc.dn_surf = [trc.dn_surf; nn_(:)];
  trc.xlens1(k) = (xx_(1) + xx_(end))/2; % Actual center
end
trc.placed = 1;
