function [p,l]=plotspacious(x,y,q)
% [p,l] = PLOTSPACIOUS(x,y,q) plots points at (X,Y), and returns a plot
% handle in P. It also plots lines between the points, but these lines
% leave a fraction Q of line length free near the points. Line plot
% handle is returned in L.
% If Q is negative, an absolute |Q| rather than a relative Q is left free.

x=x(:)'; N=length(x);

p=plot(x,y,'.');

hold on

dx = diff(x);
xn = x(N);
xi = x(1:N-1);
if q>0
  xi = [xi; xi+dx*q; xi+dx*(1-q)];
else
  xi = [xi; xi-q; xi+dx+q];
end
xi = reshape(xi,(N-1)*3,1); xi=[xi; xn];
yi = interp1(x,y,xi,'linear');
xi(1:3:end)=nan;
l=plot(xi,yi);
