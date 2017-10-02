function h=tickbar(xx,yy,ticklen,lbls,ttl,edg)
% h=TICKBAR(xx,yy,ticklen,lbls,ttl,edg) draws a single axis with ticks. 
% Either XX or YY should be a vector, determining the direction 
% of the bar. The other should be scalar. Instead of a vector, a cell array
% containing two vectors may be supplied, in which case major and minor
% ticks are generated.
% Positive TICKLEN means: to right or up, negative is left or down.
% Labels (LBLS) are drawn justified to one tick distance away from the ticks.
% Axis title (TTL) is drawn one more tick distance away.
% If TICKLEN is purely imaginary, text is on the other side.
% EDG specifies the extreme ends of the axis. If absent, the ticks determine 
% the ends.
% 
% See also: XTICKBAR, YTICKBAR, AXTICKBAR, AYTICKBAR, LXTICKBAR, LYTICKBAR.

h.li=[];
h.lb=[];
h.ttl=[];
h.ax=[];

X=length(xx);
Y=length(yy);
if X~=1 & Y~=1
  error('One of XX or YY must be scalar');
end

if nargin<4
  lbls=[];
end

if nargin<5
  ttl=[];
end

if nargin<6
  edg=[];
end

if abs(imag(ticklen(1)))>0
  ticklen = imag(ticklen);
  textdist = -ticklen;
else
  textdist = 2*ticklen;
end
if length(ticklen)==1
  minorlen=ticklen/2;
else
  minorlen=ticklen(2);
  ticklen=ticklen(1);
end

if X>1
  % Horizontal tick bar
  if iscell(xx)
    minorx=xx{2};
    xx=xx{1};
    X=length(xx);
  else
    minorx=[];
  end
  if isempty(edg)
    edg=[xx(1) xx(end)];
  end
  h.ax = line(edg,[yy yy]);
  if isempty(lbls)
    if iscell(lbls)
      for x=1:X
	lbls{x}='';
      end
    else
      lbls=num2strcell(xx);
    end
  elseif ~iscell(lbls)
    lbls=num2strcell(lbls);
  end
  for x=1:X
    h.li(x) = line(xx(x)+[0 0],yy+[0 ticklen]);
    h.lb(x) = text(xx(x),yy+textdist,lbls(x));
  end
  h.mi=[];
  for x=1:length(minorx)
    h.mi(x) = line(minorx(x)+[0 0],yy+[0 minorlen]);
  end
  set([h.ax h.li h.mi],'color','k');
  set(h.lb,'horizontala','center');
  if textdist>0
    set(h.lb,'verticala','bot');
  else
    set(h.lb,'verticala','top');
  end
  if ~isempty(ttl)
    miny=inf;
    maxy=-inf;
    for x=1:X
      ext = get(h.lb(x),'extent');
      miny = min([miny ext(2)]);
      maxy = max([maxy ext(2)+ext(4)]);
    end
    if textdist>0
      texty = maxy + abs(ticklen);;
    else
      texty = miny - abs(ticklen)*.5;
    end
    h.ttl = text(mean([xx(1) xx(end)]), texty, ttl);
    set(h.ttl,'horizontala','center');
    if textdist>0
      set(h.ttl,'verticala','bot');
    else
      set(h.ttl,'verticala','top');
    end
  end
else
  % Vertical tick bar
  if iscell(yy)
    minory=yy{2};
    yy=yy{1};
    Y=length(yy);
  else
    minory=[];
  end
  if isempty(edg)
    edg=[yy(1) yy(end)];
  end
  h.ax = line([xx xx],edg);
  if isempty(lbls)
    if iscell(lbls)
      for y=1:Y
	lbls{y}='';
      end
    else
      lbls=num2strcell(yy);
    end
  elseif ~iscell(lbls)
    lbls=num2strcell(lbls);
  end
  for y=1:Y
    h.li(y) = line(xx+[0 ticklen],yy(y)+[0 0]);
    h.lb(y) = text(xx+textdist,yy(y),lbls(y));
  end
  h.mi=[];
  for y=1:length(minory)
    h.mi(y) = line(xx+[0 minorlen],minory(y)+[0 0]);
  end
  set([h.ax h.li h.mi],'color','k');
  set(h.lb,'verticala','middle');
  if textdist>0
    set(h.lb,'horizontala','left');
  else
    set(h.lb,'horizontala','right');
  end

  if ~isempty(ttl)
    minx=inf;
    maxx=-inf;
    for y=1:Y
      ext = get(h.lb(y),'extent');
      minx = min([minx ext(1)]);
      maxx = max([maxx ext(1)+ext(3)]);
    end
    if textdist>0
      textx = maxx+abs(ticklen);
    else
      textx = minx-abs(ticklen)*1.5;
    end
    h.ttl = text(textx,mean([yy(1) yy(end)]),ttl);
%    set(h.ttl,'verticala','middle');
    set(h.ttl,'horizontala','center');
    set(h.ttl,'rota',90);
    if textdist>0
      set(h.ttl,'verticala','top');
%      set(h.ttl,'horizontala','left');
    else
      set(h.ttl,'verticala','bottom');
%      set(h.ttl,'horizontala','right');
    end
  end
end


a=axis;
%for n=1:length(h.li)
%  a=expandaxis(a,get(h.li(n),'extent'));
%end
for n=1:length(h.lb)
  a=expandaxis(a,growbox(get(h.lb(n),'extent'),.05));
end
for n=1:length(h.ttl)
  a=expandaxis(a,growbox(get(h.ttl(n),'extent'),.05));
end
%for n=1:length(h.ax)
%  a=expandaxis(a,get(h.ax(n),'extent'));
%end
axis(a);