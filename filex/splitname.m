function [dir,base,ext] = splitname(fn)
% [dir,base,ext] = SPLITNAME(fn) returns the parts of a filename.
% [dir,base] = SPLITNAME(fn) does not attempt to split an extension off.
dd = strfind(fn,filesep);
if isempty(dd)
  dir = '.';
else
  dir = fn(1:dd(end)-1);
  fn = fn(dd(end)+1:end);
end

if nargout>=3
  dd = strfind(fn,'.');
  if isempty(dd)
    ext = '';
  else
    ext = fn(dd(end)+1:end);
    fn = fn(1:dd(end)-1);
  end
end

base=fn;
