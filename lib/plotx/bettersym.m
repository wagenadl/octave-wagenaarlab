function ho=bettersym(hh,rm,sol)
% ho=BETTERSYM(hh) looks at all the plots with handles in HH, and replaces
% open plot symbols by home made versions that are not crossed by lines.
% Return is a cell array of all the newly created objects.
% ho=BETTERSYM(hh,1) removes old markers.
% ho=BETTERSYM(hh,[],1) creates solid markers.
% ho=BETTERSYM without arguments operates on all children of current axes.

if nargin<1 | isempty(hh)
  hh=get(gca,'children');
end
if nargin<2 | isempty(rm)
  rm=0;
end
if nargin<3 | isempty(sol)
  sol=0;
end  

H=length(hh);
ho=cell(1,H);
wh = oneinch/72; % 1 point
for h=1:H
  if strcmp(get(hh(h),'type'),'line')
    x=get(hh(h),'marker');
    if isempty(x)
      x='none';
    end
    axes(get(hh(h),'parent'));
    r=get(hh(h),'markersize');
    xx = get(hh(h),'xdata');
    yy = get(hh(h),'ydata');
    xr = wh(1)*r;
    yr = wh(2)*r;
    if x=='o'
      ho{h} = circles(xx,yy,xr,yr);
    elseif x(1)=='s'
      ho{h} = squares(xx,yy,xr,yr);
    elseif x=='d'
      ho{h} = diamonds(xx,yy,xr,yr);
    elseif x=='<'
      ho{h} = lefttriangles(xx,yy,xr,yr);
    elseif x=='>'
      ho{h} = righttriangles(xx,yy,xr,yr);
    elseif x=='^'
      ho{h} = uptriangles(xx,yy,xr,yr);
    elseif x=='v'
      ho{h} = downtriangles(xx,yy,xr,yr);
    end
  end
end
for h=1:H
  if ~isempty(ho{h})
    set(ho{h},'edgec',get(hh(h),'color'));
    if sol
      set(ho{h},'facec',get(hh(h),'color'));
    else
      set(ho{h},'facec','w');
    end
    if rm
      set(hh(h),'marker','none');
    end
  end
end 

if nargout<1
  clear ho
end