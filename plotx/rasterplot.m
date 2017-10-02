function h = rasterplot(xx,y0,y1,varargin)
% RASTERPLOT(xx,y0,y1) makes a raster plot of vertical ticks.
% h = RASTERPLOT(...) returns a plot handle.
% Additional arguments are passed to plot.

X=length(xx);
xx=repmat(xx(:)',[3 1]);
yy=repmat([y0 y1 nan]',[1 X]);
h = plot(xx(:),yy(:),varargin{:});
