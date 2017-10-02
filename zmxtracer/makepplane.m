function [x, f] = makepplane(varargin)
% MAKEPPLANE - Interpolated principal plane information
%    MAKEPPLANE(lens) creates an m-file with principal plane information
%    for the given lens if it doesn't exist yet.
%    [x, f] = MAKEPPLANE(wl, orient, lens) also returns that information
%    interpolated at the given wavelength.
%    This allows lenses to return a function handle to retrieve principal
%    plane information. The function will return very fast after the first
%    call ever.

lens = varargin{end};
if nargin>=2
  wl = varargin{1};
else
  wl = 532;
end
if nargin>=3
  rev = varargin{2};
else
  rev = 0;
end

if exist([lens.fn '_pp'])
  [x, f] = feval([lens.fn '_pp'], wl, rev);
  return;
end

wll = [390:10:750];
W = length(wll);
xx = zeros(W, 2);
ff = zeros(W, 2);
for w=1:W
  [xx(w, 1), ff(w,1)] = tracer_pplane(lens, 0, wll(w));
  [xx(w, 2), ff(w,2)] = tracer_pplane(lens, 1, wll(w));
end

fd = fopen(sprintf('lenses/%s_pp.m', lens.fn), 'w');

fprintf(fd, 'function [x, f] = %s_pp(wl, rev)\n', lens.fn);
fprintf(fd, 'wll = [\n');
for w=1:W
  fprintf(fd, ' %g\n', wll(w));
end
fprintf(fd, '];\n');
fprintf(fd, 'xx = [\n');
for w=1:W
  fprintf(fd, ' %g %g\n', xx(w,1), xx(w,2));
end
fprintf(fd, '];\n');
fprintf(fd, 'ff = [\n');
for w=1:W
  fprintf(fd, ' %g %g\n', ff(w,1), ff(w,2));
end
fprintf(fd, '];\n');

fprintf(fd, 'if nargin>=2 && rev\n');
fprintf(fd, '  idx=2;\n');
fprintf(fd, 'else\n');
fprintf(fd, '  idx=1;\n');
fprintf(fd, 'end\n');
fprintf(fd, 'x = interp1(wll, xx(:,idx), wl, ''linear'');\n');
fprintf(fd, 'if nargout>=2\n');
fprintf(fd, '  f = interp1(wll, ff(:,idx), wl, ''linear'');\n');
fprintf(fd, 'end\n');

fclose(fd);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin>=3 && rev
  idx=2;
else
  idx=1;
end
x = interp1(wll, xx(:,idx), wl, 'linear');
if nargout>=2
  f = interp1(wll, ff(:,idx), wl, 'linear');
end

