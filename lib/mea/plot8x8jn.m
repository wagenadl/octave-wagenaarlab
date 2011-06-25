function [hh, aa] = plot8x8jn(xx,yy,varargin)
% PLOT8X8JN - MEABench 8x8 plot generation for JN data
% PLOT8X8JN(xx,yy) plots 64 graphs of data in JN MEA shape.
% XX must be a vector of length N; YY must be Nx60 or Nx64.
% PLOT8X8JN(xx,yy, ...) specifies additional arguments to PLOT.
% [hh, aa] = PLOT8X8JN(...) returns plot and axes handles.

oldaxes = 0;
if nargin>=3
  if ~ischar(varargin{1})
    aa = xx;
    xx = yy;
    yy = varargin{1};
    oldaxes = 1;
  end
end

[N,C] = size(yy);
hh = zeros(C,1);

if ~oldaxes
  aa = zeros(C,1);
  clf
end
for c=1:C
  hw = c-1;
  [col,row] = hw2jn(hw);
  if oldaxes
    axes(aa(c));
    ish = ishold;
    hold on
  else
    aa(c) = axes('position', ...
	[0.05+.95*col/18 0.05+.95*(8-row)/9 .95/9 .95/9]);
  end
  hh(c) = plot(xx, yy(:,c), varargin{1+oldaxes:end});
  axis tight;
  if oldaxes
    if ~ish
      hold off
    end
  else
    if col>0
      set(gca,'ytickl',[]);
    end
    if row<8
      set(gca,'xtickl',[]);
    end
  end
end

if nargout<2
    clear aa
end
if nargout<1
  clear hh
end
