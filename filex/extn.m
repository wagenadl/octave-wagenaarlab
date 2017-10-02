function ext = extn(fn)
% ext = EXTN(fn) returns the extension of FN (part after last dot), or ''.

dd = strfind(fn,'.');
if ~isempty(dd)
  ext = fn(dd(end)+1:end);
else
  ext = '';
end
