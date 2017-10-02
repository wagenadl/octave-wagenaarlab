function e=derrorbarud(x,y,dy_up,dy_dn,w)
% DERRORBARUD - Plots a series of asymmetric error bars
%   DERRORBARUD(x,y,dy_up, dy_dn) plots a series of 
%   lines (x,y-dy_dn) - (x,y+dy_up).
%   h = DERRORBARUD(x, y, dy_up, dy_dn) returns line handles.
%   DERRORBARUD(..., w) additionally plots top and bottom caps of given width.
%   h = DERRORBARUD(..., w) returns an Nx3 array of handles.

% e = DERRORBARUD(x,y,dy_up,dy_dn,w)
N=length(x);
e=zeros(N,1);
for n=1:N
  e(n)=line([0 0]+x(n),[-dy_dn(n) dy_up(n)]+y(n));
end

if nargin>4
  e=[e, zeros(N,2)];
  for n=1:N
    e(n,2) = line([-w w]+x(n),[1 1]*dy_up(n)+y(n));
    e(n,3) = line([-w w]+x(n),[-1 -1]*dy_dn(n)+y(n));
  end
end
