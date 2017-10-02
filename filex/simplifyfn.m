function y = simplifyfn(x)
% SIMPLIFYFN  Simplify filenames
%   SIMPLIFYFN(x) simplifies the filename X by cleaning up occurrences of
%   '/.', '/..' and '//'.

if (length(x)>=2 & strcmp(x(1:2),[ '.' filesep])) | strcmp(x,'.')
  x = [pwd x(2:end)];
elseif (length(x)>=3 & strcmp(x(1:3),[ '..' filesep])) | strcmp(x,'..')
  x = [pwd filesep x];
end

if length(x)>0
  if x(1)==filesep | (length(x)>=3 & strcmp(x(2:3),':\'))
    ;
  elseif x(1)=='~'
    if strcmp(x,'~')
      x = getenv('HOME');
    else
      if x(2)==filesep
	x = [getenv('HOME') x(2:end)];
      else
	% Other named folder?
	idx = find(x==filesep);
	if isempty(idx)
	  l=length(x);
	else
	  l=idx(1)-1;
	end
	user = x(2:l);
	x = [ '/home/' user x(l+1:end)]; % This is _not_ how this should be done, of course.
      end
    end
  else
    x = [pwd filesep x];
  end
end

z=splitstring(x,filesep);
y={z{1}}; N=1;
for k=2:length(z)
  if strcmp(z{k},'.') | isempty(z{k})
    ;
  elseif strcmp(z{k},'..')
    N=N-1;
    if N<1
      N=0;
    end
  else
    N=N+1;
    y{N}=z{k};
  end
end
z=cell(1,N);
for n=1:N
  z{n}=y{n};
end
y = [joinstring(z,filesep)];
if isempty(y)
  y=filesep;
end