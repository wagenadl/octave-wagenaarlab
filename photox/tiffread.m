function [img,ifo] = tiffread(fn)
% TIFFREAD - Reads a multi-image tiff file
%    img = TIFFREAD(fn) reads the named file and returns a cell array
%    of images.
%    [img,ifo] = TIFFREAD(fn) also returns TIFFINFO information.
%    This function first converts the images to PNG, so that alpha information
%    can be extracted. (Matlab cannot read alpha from TIFFs.)

ifo = tiffinfo(fn);

prfx = sprintf('/tmp/tfr%.4f',rand(1));
s=unix(sprintf('tiffsplit %s %s', fn, prfx));
if s
  error('tiffread: tiffsplit failed');
end

N=length(ifo);
img=cell(1,N);
for n=1:N
  base = sprintf('%s%s',prfx,num2aaa(n));
  tiffn = sprintf('%s.tif',base);
  pngfn = sprintf('%s.png',base);
  s=unix(sprintf('convert %s %s',tiffn,pngfn));
  if s
    error('tiffread: convert failed');
  end
  [aa,bb,cc] = imread(pngfn);
  if isempty(cc)
    img{n} = aa;
  else
    img{n} = cat(3,aa,cc);
  end
  unix(sprintf('rm %s %s',tiffn,pngfn));
end

if nargout<2
  clear ifo
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function str=num2aaa(n)
n=n-1;
a=mod(n,26);
b=mod(div(n,26),26);
c=mod(div(n,26*26),26);
str=sprintf('%c%c%c','a'+c,'a'+b,'a'+a);
