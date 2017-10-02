function [x,y] = poly_xor(x1,y1, x2,y2)
% POLY_XOR - Calculate symmetric difference between two polygons
%    [x,y] = POLY_DIFFERENCE(x1,y1, x2,y2) calculates the symmetric 
%    difference between two polygons, using the PolygonClip library.

P1.x = x1;
P1.y = y1;
P1.hole = 0;

P2.x = x2;
P2.y = y2;
P2.hole = 0;

P3 = polyclip(P1,P2,2);
x = P3.x;
y = P3.y;
