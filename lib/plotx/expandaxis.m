function c=expandaxis(a,b)
% EXPANDAXIS  Find the rectangular union of two rectangles
%    c = EXPANDAXIS(a,b) returns the rectangular union of the two rectangles
%    A and B.
%    A must be specified in 'axis' form, i.e. (lx,rx,by,ty),
%    B must be specified in 'rect' form, i.e. (lx,by,w,h).
%    The result is in axis form.
c=[min([a(1),b(1)]), max([a(2),b(1)+b(3)]), ...
      min([a(3),b(2)]), max([a(4),b(2)+b(4)])];
