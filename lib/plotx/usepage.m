function usepage(w,h,norot)
% USEPAGE(w,h) uses WxH inches of space on the page for this figure.
% Auto rotates if necessary. 
% USEPAGE(w,h,1) does not autorotate

if nargin<3
  norot=0;
end

pw = 8.5;
mh = .5;
ph = 11 - mh;

set(gcf,'paperu','in');

if w>pw-.5 & ~norot
  % Must go landscape
  set(gcf,'paperor','landscape');
  set(gcf,'paperp',[(ph-w)/2+mh,(pw-h)/2,w,h]);
else
  set(gcf,'paperor','portrait');
  set(gcf,'paperp',[(pw-w)/2,(ph-h)/2+mh,w,h]);
end
