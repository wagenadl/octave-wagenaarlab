function [fn,xt] = basename(fn, ext)
% fn = BASENAME(fn) returns the leafname part of FN.
% fn = BASENAME(fn,ext) strips the given extension off of FN as well.
% fn = BASENAME(fn,[]) strips any extension off of fn as well.
% [fn,ext] = BASENAME(fn,[]) returns the extension.

if iscell(fn) 
  [N,M]=size(fn);
  if nargin>1
    for n=1:N
      for m=1:M
	fn{n,m} = basename(fn{n,m},ext);
      end
    end
  else
    for n=1:N
      for m=1:M
	fn{n,m} = basename(fn{n,m});
      end
    end
  end    
  return
end

dd = strfind(fn,filesep);
if ~isempty(dd)
  fn = fn(dd(end)+1:end);
end

xt0='';

if nargin>1
  if isempty(ext)
    dd = strfind(fn,'.');
    if ~isempty(dd)
      xt0 = fn(dd(end)+1:end);
      fn = fn(1:dd(end)-1);
    end
  else
    dd = strfind(fn,ext);
    if ~isempty(dd)
      dd=dd(end);
      if dd==length(fn)+1-length(ext)
	xt0 = fn(dd+1:end);
	fn = fn(1:dd-1);
      end
    end
  end
end
if nargout>1
  xt = xt0;
end
