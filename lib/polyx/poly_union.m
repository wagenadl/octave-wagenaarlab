function [x,y] = poly_union(x1,y1, x2,y2)
% POLY_UNION - Calculate union of two polygons
%    [x,y] = POLY_UNION(x1,y1, x2,y2) calculates the union 
%    of two polygons, using the PolygonClip library.

P1.x = x1;
P1.y = y1;
P1.hole = 0;

P2.x = x2;
P2.y = y2;
P2.hole = 0;

P3 = polyclip(P1,P2,3);
x = P3.x;
y = P3.y;

