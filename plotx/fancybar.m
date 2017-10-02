function fbh = fancybar(loc,coord,ticks,labels,name)
% FANCYBAR - Fancy tick bars
%    FANCYBAR(loc,coord,ticks,labels,name) adds a new tick bar to the 
%    current axes.
%
%    LOC must be one of 'bottom', 'left', 'top', or 'right', and determines
%    where the text goes relative to the bar. 'x' and 'y' are synonyms for
%    'bottom' and 'left'.
%
%    COORD specifies the y-position of 'bottom' or 'top' bars, or the
%    x-position of 'left' or 'right' bars.
%
%    TICKS specifies the location and style of ticks along the bar. A full
%    specification has the form
%
%       {{posns1,len1,props1}, ..., [limit]}
%
%    where POSNSi are the positions of the ticks (in data coordinates),
%    LENi are the lengths of the ticks (in inches), and PROPSi specify
%    additional properties (as (name,value) pairs).
%    Multiple sets of ticks may be specified. PROPSi is entirely optional.
%    If LENi is omitted, a default is used. 
%    If LIMIT is given and contains precisely two values, it is treated
%    as the lower and upper limit of the bar, rather than as tick positions.
%    Braces may be omitted if no LEN or PROPS are given. If only one set
%    of ticks is specified, the outer braces may also be omitted.
%
%    LABELS specifies tick labels. A full specification has the form
%
%       {{strings1,posns1,dist1,props1}, ...}.
%
%    Typically, only one set of labels will be specified, in which case the
%    outer braces may be omitted. POSNS1 may be omitted, in which case the
%    positions are taken from the first set of ticks. DISTi may be omitted,
%    in which case a default is used. PROPSi may always be omitted.
%    As a special case, LABELS may be given as [], in which case numerical
%    labels are placed by the first set of ticks. 
%    Instead of string arrays, numerical vectors may be given, which are
%    automatically converted to string arrays. These specify their own 
%    positions, unless POSNi is given.
%
%    NAME specifies the main label for the axis. A full specification has
%    the form
%
%      {label,dist,props}.
%
%    DIST and/or PROPS may be omitted. If both are omitted, the braces may
%    be omitted.
%
%    Use AUTOEXTEND to ensure that all labels are inside the axis limits,
%    and RECALCSHIFTS to recalculate label positions and tick lengths after
%    any change of figure shape.
%
%    NB: Properties cannot be specified in this call for either the main 
%    label or for the main bar. The returned handle structure must be
%    used for that:
%
%    fbh = FANCYBAR(...) returns a structure of handles:
% 
%     ticks: cell array of handle vectors, or just a vector if only one level.
%     labels: cell array of handle vectors, or just a vector if only one level.
%     name: handle of main axis label
%     axis: handle of axis itself

if nargin<3 | nargin>5
  fb_error;
else
  if nargin<4
    labels=[];
  end
  if nargin<5
    name='';
  end
end

if ~ischar(loc)
  fb_error('1st arg (LOC) must be a string');
end
if prod(size(coord))~=1 | ~isnumeric(coord)
  fb_error('2nd arg (COORD) must be a scalar coordinate');
end  

ticks = fb_canonticks(ticks);
labels = fb_canonlabels(labels,ticks);
name = fb_canonname(name);

switch loc
  case {'bottom','x'}
    ynotx = 0;
    direc = -1;
  case 'top'
    ynotx = 0;
    direc = 1;
  case {'left','y'}
    ynotx = 1;
    direc = -1;
  case 'right'
    ynotx = 1;
    direc = 1;
  otherwise
    fb_error('1st arg (LOC): Unknown location type');
end

if ynotx
  fbh.axis = line([0 0]+coord,ticks.limit,'color','k');
else
  fbh.axis = line(ticks.limit,[0 0]+coord,'color','k');
end

N=length(ticks.posns);
fbh.ticks = cell(N,1);
for n=1:N
  if ynotx
    fbh.ticks{n} = compositeticks(coord,ticks.posns{n},...
	direc*ticks.lens{n},0,...
	ticks.props{n}{:});
  else
    fbh.ticks{n} = compositeticks(ticks.posns{n},coord,...
	0,direc*ticks.lens{n},...
	ticks.props{n}{:});
  end
end

N=length(labels.posns);
fbh.labels = cell(N,1);
for n=1:N
  if ynotx
    if direc*labels.dists{n} > 0
      ha = 'left';
    else
      ha = 'right';
    end
    va = 'middle';
  else
    if direc*labels.dists{n} < 0
      va = 'top';
    else
      va = 'bottom';
    end
    ha = 'center';
  end
  
  K=length(labels.strings{n});
  fbh.labels{n}=zeros(1,K);
  for k=1:K
    if ynotx
      fbh.labels{n}(k) = shiftedtext(coord,labels.posns{n}(k),...
	  direc*labels.dists{n},0,...
	  labels.strings{n}{k},...
	  'horizontalalignment',ha,'verticalalignment',va,...
	  labels.props{n}{:});
    else
      fbh.labels{n}(k) = shiftedtext(labels.posns{n}(k),coord,...
	  0,direc*labels.dists{n},...
	  labels.strings{n}{k},...
	  'horizontalalignment',ha,'verticalalignment',va,...
	  labels.props{n}{:});
    end
  end
end

if ~isempty(name.name)
  if abs(imag(name.dist)) > abs(real(name.dist))
    if ~isempty(fbh.labels)
      usespaced = 1;
      name.dist = -i*name.dist;
    else
      usespaced = 0;
      name.dist = -i*name.dist;
    end
  else
    usespaced = 0;
  end
  
  if direc*name.dist*(ynotx-.5) > 0
    va = 'top';
  else
    va = 'bottom';
  end
  if usespaced
    if ynotx
      fbh.name = spacedtext(coord,mean(ticks.limit),...
          direc*name.dist,0,...
          fbh.labels{1},name.name,...
          'horizontalalignment','center','verticalalignment',va,'rotation',90,...
          name.props{:});
    else  
      fbh.name = spacedtext(mean(ticks.limit),coord,...
          0,direc*name.dist,...
          fbh.labels{1},name.name,...
          'horizontalalignment','center','verticalalignment',va,...
          name.props{:});
    end
  else
    if ynotx
      fbh.name = shiftedtext(coord,mean(ticks.limit),...
          direc*name.dist,0,...
          name.name,...
          'horizontalalignment','center','verticalalignment',va,'rotation',90,...
          name.props{:});
    else  
      fbh.name = shiftedtext(mean(ticks.limit),coord,...
          0,direc*name.dist,...
          name.name,...
          'horizontalalignment','center','verticalalignment',va,...
          name.props{:});
    end
  end
end

if nargout==0
  clear fbh;
else
  if length(fbh.ticks)==1
    fbh.ticks = fbh.ticks{1};
  end
  if length(fbh.labels)==1
    fbh.labels = fbh.labels{1};
  end
end
