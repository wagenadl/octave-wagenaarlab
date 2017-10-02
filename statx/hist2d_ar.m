function mat=hist2dar(X,Y,nx,ny,flag)
% mat=hist2dar(X,Y,nx,ny,flag) returns a matrix suitable for 
% pcolor containing the crosstab counts of X and Y in automatically
% selected bins: you pick the number of bins, the code determines the
% edges based on the min and max values in X and Y.
% If optional argument FLAG is present, the result is also plotted.

% matlab/hist2d_ar.m: part of meabench, an MEA recording and analysis tool
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

x0=min(X); x1=max(X); dx=(x1-x0)/nx;
y0=min(Y); y1=max(Y); dy=(y1-y0)/ny;
if nargin>=5
  hist2d(X,Y,x0,dx,x1,y0,dy,y1,1);
else 
  hist2d(X,Y,x0,dx,x1,y0,dy,y1);
end
