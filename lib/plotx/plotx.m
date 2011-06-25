function h = plotx(dt, y, varargin)
% PLOTX - Plot against a simple timebase
%    PLOTX(dt, yy) plots the data yy against time. dt is the interval between
%    samples.
%    h = PLOTX(dt, yy, ...) returns a handle and passes additional arguments
%    to PLOT.

tt=[0:length(y)-1]*dt;
h = plot(tt,y, varargin{:});
if nargout==0
  clear h
end
