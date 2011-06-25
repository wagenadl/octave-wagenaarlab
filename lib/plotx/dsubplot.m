function dsubplot(Y,X,y,x,fr);
% DSUBPLOT - Easy subplots
%    DSUBPLOT(Y,X,xy) is like SUBPLOT, but more predictable in R7.
%    DSUBPLOT(Y,X,y,x) offers a more intuitive interface.
%    DSUBPLOT(Y,X,y,x,fr) specifies what fraction of the area the plot 
%    should take. Default: 0.65.
if nargin<5
  fr=.65;
end
if nargin<4
  xy = y;
  x = mod(xy-1,X);
  y = div(xy-1,X);
else
  x=x-1;
  y=y-1;
end

f0 = (1-fr)*2/3;

axes('position',[x/X+f0/X (Y-1-y)/Y+f0/Y fr/X fr/Y]);

