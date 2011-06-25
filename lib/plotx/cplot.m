function pp=cplot(xx,yy,cc,li)
% pp=CPLOT(xx,yy,cc) plots the data (XX,YY) as a 2-D plot with dots, using
% colors in CC. Colors are evenly spaced among the data points, so that if
% there are 10 colors and 200 data points, then each group of 20 consecutive
% points are drawn in the same color.
% pp=CPLOT(xx,yy,cc,1) plots lines instead of points.

if nargin<4
  li=0;
end
C=size(cc,1);
N=length(xx);
h=ishold;
hold on
pp=zeros(C,1)+nan;

if li
  i0=1;
  for c=1:C
    i1=ceil(N * c/C);
    %t0=ceil((c-1)/C*N+.0000001);
    %t1=floor(c/C*N);
    %if t1>t0
    %  pp(c)=plot(xx(t0:t1),yy(t0:t1),'.');
    pp(c) = plot(xx(i0:i1),yy(i0:i1), '-', 'color',cc(c,:));
    i0=i1;
    %end
  end
else
  i0=0;
  for c=1:C
    i1=ceil(N * c/C);
    if i1>i0
      pp(c) = plot(xx(i0+1:i1),yy(i0+1:i1), '.', 'color',cc(c,:));
    end
    i0=i1;
  end
end
if ~h
  hold off
end

pp=pp(~isnan(pp));
