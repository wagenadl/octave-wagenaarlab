function [h,y] = elplot_xyrra(el,npts,varargin)
% ELPLOT_XYRRA  Plot an ellipse defined by center, radii, and angle.
%    ELPLOT_XYRRA(el,npts) plots an ellipse defined by its center,
%    major and minor radii and angle.
%    EL must be a structure with fields:
%      x0 = center x
%      y0 = center y
%      R  = major radius
%      r  = minor radius
%      phi= angle of major radius from positive x-axis
%    NPTS specifies the number of points to plot; default is 16.
%    ELPLOT_XYRRA(el,npts,key1,val1,...) specifies additional plot options.
%    h = ELPLOT_XYRRA(...) returns a plot handle.
%    [x,y] = ELPLOT_XYRRA(...) does not plot, but returns vertices.

if nargin<2
  npts=16;
end

omega = [0:npts]*2*pi/npts;

if ~isstruct(el)
  el=elbuild_xyrra(el);
end

xi = el.R*cos(omega);
eta = el.r*sin(omega);

cs = cos(el.phi);
sn = sin(el.phi);

x = el.x0 + cs*xi - sn*eta;
y = el.y0 + sn*xi + cs*eta;

if nargout==2
  h=x;
  return
end

h = plot(x,y,varargin{:});

if nargout<1
  clear h
end
