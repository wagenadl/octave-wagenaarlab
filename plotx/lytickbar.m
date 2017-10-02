function h=aytickbar(ttl,x0,y0,y1,ticklen,majs,mins,lbls,scl,offs)
% LYTICKBAR(ttl,x0,y0,y1,ticklen) creates a logarithmically spaced y-tickbar.
% All arguments have sensible defaults. See TICKBAR for more.
% Logarithms will be taken of y0 and y1.
% LYTICKBAR(ttl,x0,y0,y1,ticklen,majs,mins,lbls) specifies at which multiples
% of 10 major and minor ticks will be drawn.
% Labels are drawn only at LBLS. By default, LBLS==MAJS.
% LYTICKBAR(ttl,x0,y0,y1,ticklen,majs,mins,lbls,scl,offs) scales and shifts
% the tickbar to a different position on the axes.

a=axis;

if nargin<1 | isempty(ttl)
  ttl='';
end
if nargin<2 | isempty(x0)
  x0 = a(1);
end
if nargin<3 | isempty(y0)
  y0 = exp(a(3));
end
if nargin<4 | isempty(y1)
  y1 = exp(a(4));
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
for y=floor(log10(y0)):ceil(log10(y1))
  minors = [minors 10^y * mins(:)'];
end
minors = minors(minors>=y0 & minors<=y1);
majors=[];
for y=floor(log10(y0)):ceil(log10(y1))
  majors = [majors 10^y*majs(:)'];
end
majors = majors(majors>=y0 & majors<=y1);

if abs(log10(y0))>=5 | abs(log10(y1))>=5
  ytl = cell(size(majors));
  if ~isempty(find(lbls>1))
    for k=1:length(majors)
      ytl{k} = e2ten(sprintf('%.0e',majors(k)));
    end
  else
    for k=1:length(majors)
      ytl{k} = sprintf('10^{%i}',log10(majors(k)));
    end
  end
else
  ytl = num2strcell('%g',majors);
end
for k=1:length(majors)
  if isempty(find(lbls==majors(k)./10.^(floor(log10(majors(k))))))
    ytl{k}='';
  end
end
h = ytickbar({log(majors)*scl+offs,log(minors)*scl+offs},x0,ticklen,ytl,ttl,log([y0 y1])*scl+offs);
