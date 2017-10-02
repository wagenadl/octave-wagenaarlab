function yes = inrect(xy,xywh)
% INRECT  Is a point inside a rectangle?
%    INRECT(xy,xywh) returns 1 if XY falls within XYWH, 0 otherwise.

yes = (xy(1)>=xywh(1) & xy(1)<xywh(1)+xywh(3)) & ...
    (xy(2)>=xywh(2) & xy(2)<xywh(2)+xywh(4));
