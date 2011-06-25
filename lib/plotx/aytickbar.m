function h=aytickbar(ttl,x0,y0,y1,dy,dym,dyl,ticklen,scl,offs)
% AYTICKBAR(ttl,x0,y0,y1,dy,dym,dyl,ticklen,scl,offs) is an alternative way
% to call YTICKBAR, but with defaults for all arguments.

a=axis;

if nargin<1 | isempty(ttl)
  ttl='';
end
if nargin<2 | isempty(x0)
  x0 = a(1);
end
if nargin<3 | isempty(y0)
  y0 = a(3);
end
if nargin<4 | isempty(y1)
  y1 = a(4);
end
if nargin<5 | isempty(dy)
  dy = sensiblestep((y1-y0)/2);
end
if nargin<6 | isempty(dym)
  dym = sensibleminor(dy);
end
if nargin<7 | isempty(dyl)
  dyl=dy;
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

y0a = dy*ceil(y0/dy);
y1a = dy*floor(y1/dy);
y0b = dym*ceil(y0/dym);
y1b = dym*floor(y1/dym);

tks=[y0a:dy:y1a]; tkly=[dyl*ceil(y0/dyl):dyl:dyl*floor(y1/dyl)];
tkl=cell(size(tks));
for k=1:length(tks)
  if ~isempty(find(tkly==tks(k)))
    tkl{k}=num2str(tks(k));
  end
end

h = ytickbar({tks*scl+offs,[y0b:dym:y1b]*scl+offs},x0,ticklen,tkl,ttl,[y0 y1]*scl+offs);
