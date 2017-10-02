function fn = dirname(fn)
% fn = DIRNAME(fn) returns the directory part of FN.

dd = strfind(fn,filesep);
if ~isempty(dd)
  fn = fn(1:dd(end)-1);
  if isempty(fn)
    fn=filesep;
  end
else
  fn = '.';
end

