function labelstr = fb_canonlabels(labels,tickstr)
% FB_CANONLABELS - For internal use by FANCYBAR only.

if ~iscell(labels)
  if isempty(labels)
    % This is the simple case, where we are just placing automatic 
    % numerical labels by the major ticks.
    labels = num2strcell(tickstr.posns{1});
  else
    labels={labels};
  end
end

if isempty(labels)
  labelstr.strings={};
  labelstr.posns={};
  labelstr.dists={};
  labelstr.props={};
  return
end

% Now, we can have two possible styles:
%    (1) {strings,posns,dist,props}
% or
%    (2) {{strings1,posns1,dist1,props1}, ...}.
% But note that it could also be:
%    (3) {strings1,{strings2,posns2,dist2,props2}, ...}.
% So, to test whether it is truly (1), we test:
%   a. None of elements 2 through N are cells, and
%   b1. Element 1 is a numeric vector, or
%   b2. Element 1 is a cell containing strings.

N = length(labels);
type1_a=1;
for n=2:N
  if iscell(labels{n})
    type1_a=0;
    break;
  end
end  
if type1_a
  if ~iscell(labels{1})
    type1_b=1;
  else
    K=length(labels{1});
    type1_b=1;
    for k=1:K
      if ~ischar(labels{1}{k})
	type1_b=0;
	break;
      end
    end
  end
end

if type1_a & type1_b
  labels={labels};
end

% So now it is in canonical form, except that any element of LABELS could
% be just a numeric vector or a string array rather than a 
% {strings, posns,dist,props} array.

N=length(labels);
labelstr.strings=cell(N,1);
labelstr.posns=cell(N,1);
labelstr.dists=cell(N,1);
labelstr.props=cell(N,1);

for n=1:N
  if ~iscell(labels{n})
    % Numeric vector
    if isempty(labels{n}) & n==1
      labels{n}=tickstr.posns{1};
    end
    labelstr.strings{n} = num2strcell(labels{n});
    labelstr.posns = labels{n};
  else
    allstr=1;
    K=length(labels{n});
    for k=1:K
      if ~ischar(labels{n}{k})
	allstr=0;
	break;
      end
    end
    if allstr
      % Simple string array
      labelstr.strings{n} = labels{n};
    else
      % Full {strings, posns, dist, props} style.
      if ~iscell(labels{n}{1})
	% strings are given as numbers
	if isempty(labels{n}{1}) & n==1
	  labels{n}{1}=tickstr.posns{1};
	end
	labelstr.strings{n} = num2strcell(labels{n}{1});
	labelstr.posns{n} = labels{n}{1}; % This may be overwritten.
      else
	labelstr.strings{n} = labels{n}{1};
      end
      K=length(labels{n});
      if K>=3 & ~ischar(labels{n}{2}) & isnscalar(labels{n}{3})
	% This is {strings,posns,dist,...}
	labelstr.posns{n} = labels{n}{2};
	labelstr.dists{n} = labels{n}{3};
	k0=4;
      elseif K>=2 & isnscalar(labels{n}{2})
	% This is {strings,dist,...}
	labelstr.dists{n} = labels{n}{2};
	k0=3;
      elseif K>=2 & ~ischar(labels{n}{2})
	% This is {strings,posns,...}
	labelstr.posns{n} = labels{n}{2};
	k0=3;
      else
	k0=2;
      end
      if K>=k0
	labelstr.props{n} = cell(1+K-k0,1);
	if mod(1+K-k0,2)~=0
	  fb_error('4th arg (LABELS): Properties must come as KEY, VALUE pairs');
	end
	for k=k0:K
	  if mod(k-k0,2)==0 & ~ischar(labels{n}{k})
	    fb_error('4th arg (LABELS): Properties must come as KEY, VALUE pairs');
	  end
	  labelstr.props{n}{1+k-k0} = labels{n}{k};
	end
      end
    end
  end
end

if isempty(labelstr.posns{1})
  labelstr.posns{1} = tickstr.posns{1};
end

if isempty(labelstr.dists{1})
  if tickstr.lens{1}>0
    labelstr.dists{1} = 1.7*tickstr.lens{1};
  else
    labelstr.dists{1} = -tickstr.lens{1};
  end
end

for n=2:N
  if isempty(labelstr.dists{n})
    labelstr.dists{n} = labelstr.dists{1};
  end
end

for n=1:N
  if isempty(labelstr.props{n})
    labelstr.props{n}={};
  end
end
