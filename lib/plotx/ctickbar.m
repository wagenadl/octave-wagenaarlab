function yt=ctickbar(xywh,ticklen,ticks,tickl,lbl,cc)
% CTICKBAR(xywh,ticklen,ticks,tickl,lbl,cc) draws a colorbar into the 
% current axes.
% The bar is always vertical, with position specified by XYWH.
% TICKLEN is as for TICKBAR.
% TICKS specifies the positions of any ticks relative to cc.
% LBL is a text label. TICKL are tick labels.
% CC specifies the colormap to use, and defaults to the current axes' colormap.
% Normally, the tickbar is separated from the colorbar by a distance TICKLEN,
% specified in inches. If you specify TICKLEN as a two-element vector, the
% second element specifies the separation (in inches, or in axes coordinates if
% imaginary).
% 
% Example: ctickbar([10 0 .1 2],.05,[0:60:360],[],'Color',hsv(360));
%
% This new (2/14/06) edition is meant to be more intuitive by matching
% argument order to XTICKBAR and YTICKBAR.

if isempty(ticklen)
  ticklen=.05;
end
if length(ticklen)==1
  if isreal(ticklen)
    [dx,dy]=oneinch;
    dx=dx*ticklen;
  else
    dx=ticklen/i;
  end
else
  if isreal(ticklen(2))
    [dx,dy]=oneinch; dx=dx*ticklen(2);
  else
    dx=ticklen(2)/i;
  end
  ticklen=ticklen(1);
end  

if nargin<6
  cc=colormap;
end

C=size(cc,1); nn=[.5:C+.5]/(C+1);
cc=repmat(reshape(cc,[C 1 3]),[1 2 1]);
hold on
xx=xywh(1)+[.25 .75]*xywh(3);
yy=xywh(2)+nn*xywh(4);
image(xx(:),yy(:),cc);
shading flat
if isempty(tickl) & ~iscell(tickl)
  tickl=ticks;
end
if ticklen>0
  x0 = xywh(1)+xywh(3)+dx;
else
  x0 = xywh(1)-dx;
end
y=ytickbar(xywh(2)+ticks*xywh(4)/C,x0,ticklen,tickl,lbl);
if nargout>0
  yt=y;
end

