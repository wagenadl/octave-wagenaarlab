function [nfn,unq] = tabcomplete(fn,dr)
% TABCOMPLETE  Simple tab completion
%    fn = TABCOMPLETE(fn,dr) returns the tab completion of FN in
%    directory DR. This completes to longest unequivocal.
%    [fn, isuniq] = TABCOMPLETE(fn,dr) reports whether the result is unique.
dd = dir(dr);
N=length(dd);
matches=cell(1,0);
if length(fn) & fn(end)==filesep
  fn=fn(1:end-1);
  slash=1;
else
  slash=0;
end

nfn=fn; 
unq=0;

for n=1:N
  if strmatch(fn,dd(n).name)
    matches{length(matches)+1} = dd(n).name;
  end
end
if isempty(matches)
  if nargout<2
    clear unq
  end
  return
end
nfn = longestcommon(matches);
if slash
  if strcmp(nfn,fn)
    unq=1;
  else
    nfn=[fn filesep];
    unq=0;
  end
else
  unq = length(matches)==1;
end

if nargout<2
  clear unq
end
