function fn = canonpath(fn)
% CANONPATH - Canonicalize filename
%   fn = CANONPATH(fn) returns a canonical filename for FN,
%   that is a filename starting with '/', not having any '//'.

if isempty(fn)
  return
end
if length(fn)>=2 & strcmp(fn(1:2),['~' filesep])
  fn = [getenv('HOME') fn(2:end)];
end
if fn(1) ~= '/'
  fn = [pwd filesep fn];
end

fnp=strtoks(fn,filesep);
K=length(fnp);
use=ones(K,1);

for k=1:K
  if strcmp(fnp{k},'.')
    use(k)=0;
  end
  if strcmp(fnp{k},'..')
    use(k)=0;
    for l=k-1:-1:1
      if use(l)
	use(l)=0;
	break;
      end
    end
  end
end

fn='';
for k=1:K
  if use(k)
    fn = [fn filesep fnp{k}];
  end
end
