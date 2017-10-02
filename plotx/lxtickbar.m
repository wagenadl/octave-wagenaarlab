function h=axtickbar(ttl,y0,x0,x1,ticklen,majs,mins,lbls,scl,offs)
% LXTICKBAR(ttl,y0,x0,x1,ticklen) creates a logarithmicallx spaced x-tickbar.
% All arguments have sensible defaults. See TICKBAR for more.
% Logarithms will be taken of x0 and x1.
% LXTICKBAR(ttl,y0,x0,x1,ticklen,majs,mins,lbls) specifies at which multiples
% of 10 major and minor ticks will be drawn.
% Labels are drawn only at LBLS. By default, LBLS==MAJS.
% LXTICKBAR(ttl,y0,x0,x1,ticklen,majs,mins,lbls,scl,offs) scales and shifts
% the tickbar to a different position on the axes.
a=axis;

if nargin<1 | isempty(ttl)
  ttl='';
end
if nargin<2 | isempty(y0)
  y0 = a(3);
end
if nargin<3 | isempty(x0)
  x0 = exp(a(1));
end
if nargin<4 | isempty(x1)
  x1 = exp(a(2));
end
if nargin<5 | isempty(ticklen)
  ticklen = -.05;
end
if nargin<6 | isempty(majs)
  majs=1;
end
if nargin<7 | isempty(mins)
  mins= [2 3 4 5];
end
if nargin<8 | isempty(lbls)
  lbls=majs;
end
if nargin<9 | isempty(scl)
  scl=1;
end
if nargin<10 | isempty(offs)
  offs=0;
end


minors = [];
for x=floor(log10(x0)):ceil(log10(x1))
  minors = [minors 10^x * mins(:)'];
end
minors = minors(minors>=x0 & minors<=x1);
majors=[];
for x=floor(log10(x0)):ceil(log10(x1))
  majors = [majors 10^x*majs(:)'];
end
majors = majors(majors>=x0 & majors<=x1);

if abs(log10(x0))>=5 | abs(log10(x1))>=5
  xtl = cell(size(majors));
  if ~isempty(find(lbls>1))
    for k=1:length(majors)
      xtl{k} = e2ten(sprintf('%.0e',majors(k)));
    end
  else
    for k=1:length(majors)
      xtl{k} = sprintf('10^{%i}',log10(majors(k)));
    end
  end
else
  xtl = num2strcell('%g',majors);
end
for k=1:length(majors)
  if isempty(find(lbls==majors(k)./10.^(floor(log10(majors(k))))))
    xtl{k}='';
  end
end
h = xtickbar({log(majors)*scl+offs,log(minors)*scl+offs},y0,ticklen,xtl,ttl,log([x0 x1])*scl+offs);
