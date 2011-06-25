function tickstr = fb_canonticks(ticks)
% FB_CANONTICKS - Internal use by FANCYBAR only.

if ~iscell(ticks)
  % Simple form [posns] is equivalent to {[posns]}
  ticks = {ticks};
end

% Now, we can have two possible styles:
%    (1) {posns,len,props}
% or
%    (2) {{posns1,len1,props1}, ..., limit}.
% But note that it could also be:
%    (3) {posns1,{posns2,len2,props2}, ..., limit}.
% So, to see if we have the first form, we use this heuristic:
%    a. No element of TICKS is a cell array, and
%    b1. TICKS has length 1, or
%    b2. TICKS{2} is a scalar, or
%    b3. TICKS contains at least one string element.

N = length(ticks);
type1_a = 1;
for n=1:N
  if iscell(ticks{n})
    type1_a = 0;
    break;
  end
end
if type1_a
  if N==1
    type1_b = 1;
  elseif N>=2 & isnscalar(ticks{2})
    type1_b = 1;
  else
    type1_b = 0;
    for n=2:N
      if ischar(ticks{n})
	type1_b = 1;
	break;
      end
    end
  end
end

if type1_a & type1_b
  ticks={ticks};
end

% So now it is in canonical form, except that any element of TICKS can
% still be just a vector of posns rather than a cell. Also, not all elements
% may have length information.

tickstr.limit=[];

N = length(ticks);
if N>1
  if ~iscell(ticks{N}) & length(ticks{N})==2
    tickstr.limit = ticks{N};
    N=N-1;
  end
end

tickstr.posns=cell(N,1);
tickstr.lens=cell(N,1);
tickstr.props=cell(N,1);
  
for n=1:N
  if iscell(ticks{n})
    tickstr.posns{n} = ticks{n}{1};
    K=length(ticks{n});
    if K>=2
      if isnscalar(ticks{n}{2})
	tickstr.lens{n}=ticks{n}{2};
	k0=3;
      else
	k0=2;
      end
      if K>=k0
	tickstr.props{n} = cell(1+K-k0,1);
	if mod(1+K-k0,2)~=0
	  fb_error('3rd arg (TICKS): Properties must come as KEY, VALUE pairs');
	end
	for k=k0:K
	  if mod(k-k0,2)==0 & ~ischar(ticks{n}{k})
	    fb_error('3rd arg (TICKS): Properties must come as KEY, VALUE pairs');
	  end
	  tickstr.props{n}{1+k-k0} = ticks{n}{k};
	end
      end
    end
  else
    tickstr.posns{n} = ticks{n};
  end
end

if isempty(tickstr.lens{1})
  tickstr.lens{1} = .05;
end
for n=2:N
  if isempty(tickstr.lens{n})
    tickstr.lens{n} = tickstr.lens{n-1} * .6;
  end
end

if isempty(tickstr.limit)
  N=length(tickstr.posns);
  x0=inf;
  x1=-inf;
  for n=1:N
    x0=min(x0,min(tickstr.posns{n}));
    x1=max(x1,max(tickstr.posns{n}));
  end
  tickstr.limit = [x0 x1];
end

for n=1:N
  if isempty(tickstr.props{n})
    tickstr.props{n}={};
  end
end
