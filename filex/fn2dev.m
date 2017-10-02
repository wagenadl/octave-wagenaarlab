function dev = fn2dev(fn)
% dev = FN2DEV(fn) returns a device name appropriate for printing into FN.
% Currently known devices are:
%
%  eps -> epsc2
%  png -> png
%  jpg -> jpeg
%  tif -> tiff
%
% If no match, returns the file extension.

[bas,ext] = basename(fn,[]);

exts = { 'eps',   'png', 'jpg',  'tif'  };
devs = { 'epsc', 'png', 'jpeg', 'tiff' };

nn = strmatch(ext,exts,'exact');
if ~isempty(nn)
  dev = devs{nn(1)};
else
  dev = ext;
end
