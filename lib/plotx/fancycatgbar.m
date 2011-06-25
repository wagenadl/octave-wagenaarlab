function fbh = fancycatgbar(ticks,labels,name,loc,coord)
% FANCYCATGBAR - Fancy tick bars for category data
%    FANCYCATGBAR(ticks,labels) adds a new category tick bar to 
%    the current axes.
%    TICKS are the locations of the ticks which separate the categories,
%    and LABELS are the (string) labels for the categories. You do not 
%    need to specify positions for the labels: they are automatically 
%    placed between the ticks.
%    For convenience, LABELS may be specified as a space separated string
%    rather than as a cell array.
%    TICKS and LABELS may also contain additional properties, as for FANCYBAR.
%    FANCYCATGBAR(ticks,labels,name) specifies a name for the bar.
%    FANCYCATGBAR(ticks,labels,name,loc,coord) specifies a location other 
%    than 'below the x-axis' (at y=0).
%    h = FANCYCATGBAR(...) returns a structure of handles, as from FANCYBAR.
%
%    Example: FANCYCATGBAR([.5:3.5],'One Two Three'},'Groups') is
%    equivalent to FANCYCATGBAR([.5:3.5],{'One','Two','Three'},'Groups'),
%    or FANCYBAR('x',0,[.5:3.5],{{'One','Two','Three'},[1:3]},'Groups').

if nargin<2 | nargin>5
  fb_error;
else
  if nargin<3
    name='';
  end
  if nargin<4
    loc='x';
  end
  if nargin<5
    coord=00';
  end
end

if iscell(ticks)
  crd=ticks{1};
else
  crd=ticks;
end
if ischar(labels)
  labels=strtoks(labels);
end
if ~iscell(labels{1})
  labels={labels};
end
lbls={labels{1}};
lbls{2}=(crd(1:end-1)+crd(2:end))/2;
if length(labels)>=2
  if isnscalar(labels{2})
    k0=2;
  else
    lbls{3} = 0.03;
    k0=3;
  end
  for k=k0:length(labels)
    lbls{k+1} = labels{k};
  end
else
  lbls{3} = 0.03;
end

fancybar(loc,coord,ticks,lbls,name);
