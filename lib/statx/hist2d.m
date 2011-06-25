function [mat,xx,yy]=hist2d(X,Y,x0,dx,x1,y0,dy,y1,flag)
% mat=hist2d(X,Y,x0,dx,x1,y0,dy,y1,flag) returns a matrix suitable for 
% pcolor containing the crosstab counts of X and Y in the bins edges defined by
% x0:dx:x1 resp y0:dy:y1.
% If optional argument FLAG is present, the result is also plotted.
% [mat,xx,yy]=hist2d(...) returns x and y vectors as well, so you can
% call imagesc(xx,yy,mat').

% matlab/hist2d.m: part of meabench, an MEA recording and analysis tool
% Copyright (C) 2000-2002  Daniel Wagenaar (wagenaar@caltech.edu)
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


X=X(:)';
Y=Y(:)';
xx=[x0:dx:x1]';
yy=[y0:dy:y1];
nx=length(xx);
ny=length(yy);
x=floor((X-x0)/dx);
y=floor((Y-y0)/dy);
idx=find(x>=0 & x<nx & y>=0 & y<ny);
x=x(idx)+1;
y=y(idx)+1;
x=cat(2,x,[1:nx],(nx+1)*ones(1,ny));
y=cat(2,y,(ny+1)*ones(1,nx),[1:ny]);
mat=crosstab(x,y);
mat=mat(1:nx,1:ny);

if nargin>=9
  if flag ~= 0
    imagesc(xx,yy,mat');
    shading flat
    colorbar
  end
end

  

