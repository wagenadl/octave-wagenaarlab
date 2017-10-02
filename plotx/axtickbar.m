function h=axtickbar(ttl,y0,x0,x1,dx,dxm,dxl,ticklen,scl,offs)
% AXTICKBAR(ttl,y0,x0,x1,dx,dxm,dxl,ticklen,scl,offs) is an alternative way to call
% XTICKBAR, but with defaults for all arguments.

a=axis;

if nargin<1 | isempty(ttl)
  ttl='';
end
if nargin<2 | isempty(y0)
  y0 = a(3);
end
if nargin<3 | isempty(x0)
  x0 = a(1);
end
if nargin<4 | isempty(x1)
  x1 = a(2);
end
if nargin<5 | isempty(dx)
  dx = sensiblestep((x1-x0)/2);
end
if nargin<6 | isempty(dxm)
  dxm = sensibleminor(dx);
end
if nargin<7 | isempty(dxl)
  dxl=dx;
end
if nargin<8 | isempty(ticklen)
  ticklen = -.05;
end
if nargin<9 | isempty(scl)
  scl=1;
end
if nargin<10 | isempty(offs)
  offs=0;
end

x0a = dx*ceil(x0/dx);
x1a = dx*floor(x1/dx);
x0b = dxm*ceil(x0/dxm);
x1b = dxm*floor(x1/dxm);

tks=[x0a:dx:x1a]; tklx=[dxl*ceil(x0/dxl):dxl:dxl*floor(x1/dxl)];
tkl=cell(size(tks));
for k=1:length(tks)
  if ~isempty(find(tklx==tks(k)))
    tkl{k}=num2str(tks(k));
  end
end

h = xtickbar({tks*scl+offs,[x0b:dxm:x1b]*scl+offs},y0,ticklen,tkl,ttl,[x0 x1]*scl+offs);
