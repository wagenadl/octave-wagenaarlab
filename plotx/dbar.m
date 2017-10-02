function h = dbar(xx,yy,w,varargin)
% DBAR - Plot a series of rectangles
%    DBAR(xx,yy,w) plots a series of rectangles centered at XX with width
%    W and extending from the x-axis to YY. W may be either a scalar or
%    a vector the same size of XX and YY.
%    DBAR(xx,yy) automatically sets W to the (average) spacing between XX.
%    DBAR(xx,yy,w,k1,v1,...) sets parameters for the rectangles.
%    hh = DBAR(...) returns plot handles.

if nargin<3
  w=mean(diff(xx));
end
N = length(xx);
if length(w)==1
  w=repmat(w,size(xx));
end
h=zeros(size(xx));
for n=1:N
  y0 = min(yy(n),0);
  y1 = max(yy(n),0);
  h(n) = rectangle('position',[xx(n)-w(n)/2,y0,w(n),y1-y0], varargin{:});
end

if nargout<1
  clear h;
end

