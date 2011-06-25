function namestr = fb_canonname(name)
% FB_CANONNAME - For internal use by FANCYBAR only.

namestr.dist=[];
namestr.props={};

if iscell(name)
  N=length(name);
  namestr.name = name{1};
  if N>=2
    if ischar(name{2})
      n0=2;
    else
      namestr.dist = name{2};
      n0=3;
    end
    namestr.props=cell(1+N-n0,1);
    if mod(1+N-n0,2)~=0
      fb_error('5th arg (NAME): Properties must come as KEY, VALUE pairs');
    end
    for n=n0:N
      if mod(n-n0,2)==0 & ~ischar(name{n})
	fb_error('5th arg (NAME): Properties must come as KEY, VALUE pairs');
      end
      namestr.props{1+n-n0} = name{n};
    end
  end
else
  namestr.name = name;
end

if isempty(namestr.dist)
  namestr.dist = i * .03; % Imaginary: relative to labels.
  %namestr.dist = .2; % Real: relative to axis.
end