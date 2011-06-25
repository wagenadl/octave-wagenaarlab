function [h,c] = plotcplx(x,z)
% PLOTCPLX(x,z) plots |Z| against the real variable X.
% Each point is colored according to arg(Z).
% h = PLOTCPLX(x,z) returns a 2x360 array of plot handles:
% H(1,:) are the dots at each of angles [0:357] degrees.
% H(2,:) are line segments. Some of these plot handles are likely to be NaN,
% because not all angles may occur. Therefore, you may want to use, e.g.,
% nonan(h(:)) to get all handles, or nonan(h(1,:)) to get only dot handles.
% [h, c] = PLOTCPLX(x,z) adds a colorbar to the plot, and returns its handle.
x=x(:)';
z=z(:)';
clr=hsv(360);
clr=clr([[181:360] [1:180]],:);
y = abs(z);
a = 180*angle(z)/pi;
a(a<0)=a(a<0)+360;
a=1+floor(a);
h=zeros(2,360)+nan;
for q=1:360
  idx=find(a==q);
  if ~isempty(idx);
    h(1,q)=plot(x(idx),y(idx),'.', 'color',clr(q,:));
    hold on
    idx=idx(idx<length(x) & idx>1);
    if ~isempty(idx)
      x1=x(idx);
      x2=x(idx+1);
      x0=x(idx-1);
      y1=y(idx);
      y2=y(idx+1);
      y0=y(idx-1);
      xx=[(x0+x1)/2; x1; (x1+x2)/2; nan*x1];
      yy=[(y0+y1)/2; y1; (y1+y2)/2; nan*x1];
      h(2,q) = plot(xx(:),yy(:),'-','color',clr(q,:));
    end
  end
end

caxis([0 360]); % This makes COLORBAR behave properly

if nargout==0
  clear h
end

if nargout>1
  c = colorbar;
  set(c,'ytick',[1.5:60-1/6:360.5])
  set(c,'ytickl',[0:60:360]);
end