function [xx, rr, fn] = tracer_lens2surf(lens, rev, align, wavelength)
% TRACER_LENS2SURF - Convert lens data to surface data
%    [xx, rr, fn] = TRACER_LENS2SURF(lens) returns surface information
%    for the LENS placed with final surface at location x=0.
%    [xx, rr, fn] = TRACER_LENS2SURF(lens, 1) reverses the lens and
%    places the first surface at location x=0.
%    [xx, rr, fn] = TRACER_LENS2SURF(lens, orient, align) specifies
%    which plane is to be placed at x=0:
%      ALIGN = 0: center of lens (default)
%              1: first principal plane
%              2: second principal plane
%              3: first surface
%              4: last surface
%    For placement at principal planes, we need to do some calculations
%    that are wavelength dependent. By default, 532 nm is used as a
%    wavelength. To specify another wavelength:
%    [xx, rr, fn] = TRACER_LENS2SURF(lens, orient, align, wavelength)

if nargin<2
  rev = 0;
end
if nargin<3
  align = 0;
end
if nargin<4
  wavelength = 532;
end

xx = [0 cumsum(lens.tc)];
z = lens.curv==0;
rr = 0*xx + inf;
rr(~z) = 1./lens.curv(~z);

if rev
  xx = -fliplr(xx);
  rr = -fliplr(rr);
end
switch align
  case 0
    xx = xx - (xx(1)+xx(end))/2;
  case 1
    xx = xx - (xx(1)+xx(end))/2;
    xx = xx + tracer_pplane(lens, ~rev, wavelength);
  case 2
    xx = xx - (xx(1)+xx(end))/2;
    xx = xx - tracer_pplane(lens, rev, wavelength);
  case 3
    xx = xx - xx(1);
  case 4
    xx = xx - xx(end);
end

if rev
  fn{1} = lens.glass{end};
  for k=1:length(lens.glass)-1
    fn{k+1} = @(x) (lens.glass{end-k}(x)/lens.glass{end-k+1}(x));
  end
  fn{end+1} = @(x) (1/lens.glass{1}(x));
else
  fn{1} = lens.glass{1};
  for k=1:length(lens.glass)-1
    fn{k+1} = @(x) (lens.glass{k+1}(x)/lens.glass{k}(x));
  end
  fn{end+1} = @(x) (1/lens.glass{end}(x));
end
