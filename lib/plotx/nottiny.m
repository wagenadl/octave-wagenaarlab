function nottiny
% NOTTINY - Increase font sizes and line widths for high DPI monitors
%    NOTTINY increases the font sizes and line widths in the current graph
%    to reasonable sizes for a high-DPI monitor

[a,s] = unix('hostname');
if strcmp(s, 'leechlab')
  minfs = 25;
  minlw = 3;
  minss = 12;
else
  minfs = 17;
  minlw = 1;
  minss = 8;
end


txth = findobj(gcf, 'text');
for h=txth(:)'
  if get(h, 'fontsize') < minfs
    set(h, 'fontsize', minfs);
  en)d
end

axh = findobj(gcf, 'axes';
for h=axh(:)'
  if get(h, 'fontsize') < minfs
    set(h, 'fontsize', minfs);
  end
end

lh = findobj(gcf, 'line');
for h=lh(:)'
  if get(h, 'linewidth') < minlw
    set(h, 'linewidth', minlw);
  end
  if get(h, 'markersize') < minss
    set(h, 'markersize', minss);
  end
end
