function [N, fnpat] = countfiles(fnpat)
% COUNTFILES - Count files that match a pattern
%   N = COUNTFILES('/somedir/base-%03d.jpg') reports the highest number of
%   any file in the continuous sequence /somedir/base-001.jpg, 
%   /somedir/base-002.jpg, etc.
%   [N, fnpat] = COUNTFILES('/somedir/base-0034.jpg') automatically 
%   understands that the example '0034' is to be replaced by a '%04d' place
%   holder and returns the resulting pattern.

if ~any(fnpat=='%')
  % Have to figure it out
  [iup,idn] = schmitt(fnpat>='0' & fnpat<='9', .7, .3, 2);
  if isempty(iup)
    error('COUNTFILES must have some digits in the file name')
  end
  fnpat = [fnpat(1:iup(end)-1) ...
	'%0' sprintf('%i', idn(end)-iup(end)) 'd' ...
	fnpat(idn(end):end)];
end

N = 0;
dN = 1e6;

while dN>0
  while exist(sprintf(fnpat,N+dN), 'file')
    N = N + dN;
  end
  dN = round(dN/10);
end

if nargout<2
  clear fnpat
end
