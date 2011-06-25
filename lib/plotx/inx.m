function idx = inx(xx)
% idx = INX(xx) returns the indices of those values of XX that are inside
% the range of the x-axis of the current figure (axes).

a=axis;
idx = find(xx>=a(1) & xx<=a(2));
