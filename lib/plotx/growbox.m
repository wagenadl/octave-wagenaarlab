function xywh = growbox(xywh, dwh_in) 
% GROWBOX   Grow a box by a given margin
%    xywh = GROWBOX(xywh, marg) grows the box XYWH (specified in axis
%    coordinates) by the margin MARG (specified in inches).
xy = oneinch;
xywh(1) = xywh(1)-xy(1)*dwh_in;
xywh(2) = xywh(2)-xy(2)*dwh_in;
xywh(3) = xywh(3)+2*xy(1)*dwh_in;
xywh(4) = xywh(4)+2*xy(2)*dwh_in;
