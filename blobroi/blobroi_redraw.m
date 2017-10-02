function blobroi_redraw(h)
% BLOBROI_REDRAW - Main redraw function for blobroi
%   This redraws the centroids of all ROIs and the outline of the selected
%   ROI.
if nargin<1
  h=gcf;
end
blobs = getappdata(h,'blob_blobs');
idx = getappdata(h,'blob_idx');
hh = getappdata(h,'blob_outline_hh');
axh = getappdata(h,'blob_axes_h');
for k=1:length(blobs)
  if length(hh)<k
    hh(k)=nan;
    if isnan(hh(k))
      axes(axh);
      x=ishold;
      hold on
      hh(k) = plot(1,1,'k.');
      if ~x
	hold off
      end
    end
  end
  if k==idx
    set(hh(k),'xdata',blobs{k}(:,1), 'ydata',blobs{k}(:,2), ...
	'color',[1 0 1], ...
	'linest','-','marker','none');
  else
    set(hh(k),'xdata',mean(blobs{k}(:,1)), 'ydata',mean(blobs{k}(:,2)), ...
	'color',[0 1 1], ...
	'linest','none','marker','.');
  end
end
setappdata(h,'blob_outline_hh',hh);
set(gcf,'doublebuffer','on');