function p=orbarrow(x,y,nn);
% p=ADDARROW(x,y,nn)

a=axis;
ys=a(4)-a(3);
xs=a(2)-a(1);
rat=sqrt(ys/xs);
w=.01; h=.02; dn=15;
hold on
p=[];
N=length(x);
for n=nn
  x0=x(n);
  y0=y(n);
  dx = x(n+dn)-x(n-dn);
  dy = y(n+dn)-y(n-dn);
  dx=dx*rat; dy=dy/rat;
  dr = sqrt(dx.^2+dy.^2);
  dx=dx/dr; dy=dy/dr;
  dx1=w*dy - h*dx; dy1=-w*dx - h*dy;
  dx2=-w*dy - h*dx; dy2=w*dx - h*dy;
  p=[p plot([dx1 0 dx2] * xs + x0, [dy1 0 dy2] * ys + y0)];
end
