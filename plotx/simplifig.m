function simplifig
% SIMPLIFIG simplifies the current axes (subplot) by dropping all data
% points that are outside the current x-axis zoom.
% This is mainly useful for line graphs and the like.

cc = get(gca,'children'); C=length(cc);
a=axis;
x0 = a(1);
x1 = a(2);

for c=1:C
  xx = get(cc(c),'xdata');
  yy = get(cc(c),'ydata');
  zz = get(cc(c),'zdata');
  
  idx = xx>=x0 & xx<=x1;

  xx=xx(idx);
  yy=yy(idx);
  if ~isempty(zz)
    zz=zz(idx);
  end
  
  set(cc(c),'xdata',xx);
  set(cc(c),'ydata',yy);
  set(cc(c),'zdata',zz);
end

    