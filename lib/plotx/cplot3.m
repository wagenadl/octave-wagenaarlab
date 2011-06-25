function pp=cplot3(xx,yy,zz,cc)
% pp=CPLOT3(xx,yy,zz,cc) plots the data (XX,YY,ZZ) as a 3-D plot with dots, 
% using colors in CC. 
% Colors are evenly spaced among the data points, so that if there are 10 
% colors and 200 data points, then each group of 20 consecutive points
% are drawn in the same color.

C=size(cc,1);
N=length(xx);
h=ishold;
pp=zeros(C,1)+nan;
for c=1:C
  t0=ceil((c-1)/C*N+.0000001);
  t1=floor(c/C*N);
  if t1>t0
    pp(c)=plot3(xx(t0:t1),yy(t0:t1),zz(t0:t1),'.');
    set(pp(c),'color',cc(c,:));
  end
  hold on
end
if ~h
  hold off
end
pp=pp(~isnan(pp));
