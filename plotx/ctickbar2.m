function yt=ctickbar2(xywh,ticks,tickl,lbl,cc,ticklen)
% CTICKBAR2(xywh,ticks,tickl,lbl,cc) draws a colorbar into the 
% current axes.
% The bar is always vertical, with position specified by XYWH.
% TICKS specifies the positions of any ticks relative to cc.
% LBL is a text label. TICKL are tick labels.
% CC specifies the colormap to use.
%
% This function is retained for compatibility. 
% Better to use CTICKBAR in new code.

if nargin<5
  cc=colormap;
end
if nargin<6
  ticklen=.05;
end

C=size(cc,1); nn=[.5:C+.5]/(C+1);
cc=repmat(reshape(cc,[C 1 3]),[1 2 1]);
hold on
xx=xywh(1)+[.5 .75]*xywh(3);
yy=xywh(2)+nn*xywh(4);
image(xx(:),yy(:),cc);
shading flat
if isempty(tickl) & ~iscell(tickl)
  tickl=ticks;
end
y=ytickbar(xywh(2)+ticks*xywh(4)/C,xywh(1)+xywh(3),ticklen,tickl,lbl);
if nargout>0
  yt=y;
end

