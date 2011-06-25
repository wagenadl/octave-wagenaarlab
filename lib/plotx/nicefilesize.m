function str = nicefilesize(bytes)
% NICEFILESIZE  Nice representation of a file size
%    str = NICEFILESIZE(bytes) returns strings like '3467 b', '34.2 K', or
%    '177 M'.
bytes=double(bytes);
if bytes<10000
  str = sprintf('%i b',bytes);
else 
  multi=1;
  suf = 'KMGT???????????';
  bytes=bytes/1024;
  while bytes>10000
    multi=multi+1;
    bytes=bytes/1024;
  end
  if bytes<100
    str = sprintf('%.1f %s',bytes,suf(multi));
  else
    str = sprintf('%.0f %s',bytes,suf(multi));
  end
end
