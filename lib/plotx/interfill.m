function [l1,l2,a1g2,a2g1] = interfill(xx,yy1,yy2)
% INTERFILL(xx,yy1,yy2) plots curves (XX,YY1) and (XX,YY2) and fills
% the areas where YY1>YY2 blue, and those where YY2>YY1 red.
% [l1,l2,a1g2,a2g1] = INTERFILL(xx,yy1,yy2) returns handles for lines and
% areas. (A1G2 means "Areas where YY1 is Greater than YY2".)
% For convenience, YY1 or YY2 may be [], in which case no fill is made,
% and only the other line is plotted. In this case L1 or L2 will be returned
% [], and so will A1G2 and A2G1.

xx=xx(:);
yy1=yy1(:);
yy2=yy2(:);

ish = ishold;
if ~ish
  cla;
end
hold on

if ~isempty(yy1) & ~isempty(yy2)

  idx = yy1>yy2;
  didx = diff([0; idx; 0]);
  up = find(didx>0);
  dn = find(didx<0)-1;
  K = length(up);
  a1g2 = zeros(K,1);
  for k=1:K
    x_ = [xx(up(k):dn(k)); xx([dn(k):-1:up(k)])];
    y_ = [yy1(up(k):dn(k)); yy2([dn(k):-1:up(k)])];
    a1g2(k) = patch(x_,y_,'r');
  end
  
  idx = yy2>yy1;
  didx = diff([0; idx; 0]);
  up = find(didx>0);
  dn = find(didx<0)-1;
  K = length(up);
  a2g1 = zeros(K,1);
  for k=1:K
    x_ = [xx(up(k):dn(k)); xx([dn(k):-1:up(k)])];
    y_ = [yy2(up(k):dn(k)); yy1([dn(k):-1:up(k)])];
    a2g1(k) = patch(x_,y_,'b');
  end
  
  set([a1g2; a2g1],'edgec','none');
else
  a1g2=[];
  a2g1=[];
end

if ~isempty(yy1)
  l1 = plot(xx,yy1,'r');
else
  l1=[];
end

if ~isempty(yy2)
  l2 = plot(xx,yy2,'b');
else
  l2=[];
end

if ~ish
  hold off
end

if nargout==0
  clear
end
