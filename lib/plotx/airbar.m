function p=airbar(x,y,w)
if nargin<3
  w=.5*median(diff(x));
end
x=x(:);
y=y(:);
if length(w)==1
  w=repmat(w,length(x),1);
else
  w=w(:);
end
[xx,oo]=sort(x);
xx1 = xx-w(oo);
xx2 = xx+w(oo);
yy1 = y(oo);
yy2 = y(oo);
xx3 = nan+xx1;
yy3 = nan+yy1;
xx=[xx1'; xx2'; xx3'];
yy=[yy1'; yy2'; yy3'];

p=plot(xx(:),yy(:));

