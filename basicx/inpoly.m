function yes = inpoly(xy,xyxy)
% INPOLY  Does a point lie inside a given polygon?
%    INPOLY(xy,xyxy) returns 1 if the point XY lies inside the polygon
%    defined by the points XYXY (Nx2).

[N,D]=size(xyxy);
xyxy1=xyxy([[2:N] 1],:);

dx=xyxy(:,1)-xy(1);
dy=xyxy(:,2)-xy(2);
dx_=xyxy1(:,1)-xy(1);
dy_=xyxy1(:,2)-xy(2);
sg = sign(dx.*dy_ - dy.*dx_);
sg=sg*sg(1);
yes = ~any(sg<0);
