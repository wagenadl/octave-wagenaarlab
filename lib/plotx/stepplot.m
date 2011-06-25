function h = stepplot(xx,yy,con)
% STEPPLOT(xx,yy) plots the data (XX,YY) using horizontal lines at y=y_k 
% from x=x_k to x=x_(k+1).
% STEPPLOT(xx,yy,1) adds vertical connectors at y=y_k.
% h = STEPPLOT(...) returns plot handle.
%
% See also TRANSBAR.

if nargin<3
  con=0;
end

xx=xx(:)';
yy=yy(:)';

xx=[xx(1:end-1); xx(2:end); xx(2:end)];
yy=[yy(1:end-1); yy(1:end-1); yy(2:end)];

if ~con
  yy(3,:)=nan;
end

h = plot(xx,yy);

if nargout<1
  clear h
end
