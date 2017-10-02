function ctickbar(xywh,ticks,lbl,left)
% CTICKBAR(xywh,ticks,lbl) draws a colorbar into the current figure
% The bar is always vertical, with position specified by XYWH.
% TICKS specifies the positions of any ticks, in caxis coordinates
% LBL is a text label.
if nargin<4
  left=0;
end
cc=[0:.001:1];
xx=[0*cc; 0*cc+1];
yy=[cc; cc];
cax=caxis;
hold on
surf(xywh(1)+xx*xywh(3),xywh(2)+yy*xywh(4),0*yy,cc*diff(cax)+cax(1)); 
shading flat

if left
  sgn=-1;
  xx=xywh(1);
else
  sgn=1;
  xx=xywh(1)+xywh(3);
end

ytickbar(xywh(2)+(ticks-cax(1))*xywh(4)/diff(cax),...
    xx,sgn*.05,num2strcell(ticks),lbl);
