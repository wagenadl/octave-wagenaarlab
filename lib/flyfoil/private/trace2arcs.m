function arcs = trace2arcs(xx, yy, eps, pltflg)
% TRACE2ARCS - Convert a traced curve to arcs
%    arcs = TRACE2ARCS(xx, yy, eps) converts a traced curve to circular arcs.
%    XX, YY must be from TRACEFOIL.
%    EPS is the maximum tolerated deviation from the actual curve. Typically,
%    EPS = 2/DPI is a reasonable value.
%    TRACE2ARCS(xx, yy, eps) draws the results rather than returning them.
%    arcs = TRACE2ARCS(xx, yy, eps, 1) also draws the results.

if nargin<4
  pltflg = 0;
end
if nargout==0;
  pltflg = 1;
end

% We'll be splitting the trace into as many arcs as needed to assure single
% pixel error below EPS.
% One way to do this, is to do a three-point circle fit.
% I found code on MatlabCentral to do that.

% We'll start with two parts, and recursively split those as needed:
L = length(xx);
L2 = round(L/2);
arcs1 = fitarcs(xx(1:L2), yy(1:L2), eps);
arcs2 = fitarcs(xx(L2:end), yy(L2:end), eps);
arcs = catstr(arcs1, arcs2);

if pltflg
  figure(1); clf
  plot(xx, yy, 'k');
  nottiny
  plotarcs(arcs);
  nottiny
  a=max(abs(axis))
  axis([-a a -a a])
  axis square;
  fprintf(1, 'Got %i arcs\n', length(arcs.R));
end

if nargout==0
  clear arcs
end
