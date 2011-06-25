function hh = compositeticks(xx,yy,dx,dy,varargin)
% COMPOSITETICKS - Place ticks with length specified in inches
%    COMPOSITETICKS(xx,yy,dx,dy) places ticks (i.e. short lines) starting
%    at positions (XX,YY), specified in data coordinates, and extending
%    (DX,DY), specified in inches.
%    COMPOSITETICKS(xx,yy,dx,dy, pname1, pval1, ...) specifies additional
%    properties.
%    hh = COMPOSITETICKS(...) returns object handles for each tick.
%    After any change of AXIS or PAPERPOSITION, it is critical to call
%    RECALCSHIFTS to properly position the ticks.
%    Either XX or YY may be a scalar, in which case the same value will be
%    used for all ticks.

[xi,yi] = oneinch;

if length(xx)==1
  xx=repmat(xx,size(yy));
elseif length(yy)==1
  yy=repmat(yy,size(xx));
end

N=length(xx);

hh=zeros(1,length(xx));
for n=1:N
  hh(n) = shiftedplot(xx(n)+[0 0],yy(n)+[0 0],...
      [0 dx],[0 dy],'color','k',varargin{:});
%  setappdata(hh(n),'compositeticks_data',[xx(n) yy(n) dx dy]);
end

if nargout<1
  clear hh;
end
