function e=derrorbar(x,y,dy,w)
% DERRORBAR - Plots a series of symmetric error bars
%   DERRORBAR(x,y,dy) plots a series of lines (x,y+-dy).
%   h = DERRORBAR(x,y,dy) returns line handles
%   DERRORBAR(x,y,dy,w) additionally plots top and bottom caps of given width
%   h = DERRORBAR(x,y,dy,w) returns an Nx3 array of handles
%   See DERRORBARUD for a similar function that accepts asymmetric errors
N=length(x);
e=zeros(N,1);
for n=1:N
  e(n)=line([0 0]+x(n),[-1 1]*dy(n)+y(n));
end

if nargin>3
  e=[e zeros(N,2)];
  for n=1:N
    e(n,2) = line([-w w]+x(n),[1 1]*dy(n)+y(n));
    e(n,3) = line([-w w]+x(n),[-1 -1]*dy(n)+y(n));
  end
end
