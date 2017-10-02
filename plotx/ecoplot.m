function h=ecoplot(xx, yy, N, lns)
if nargin<4
  lns = 0;
end

K=length(yy);
ii=1+ceil([0:N]/N * (K-1));
[ym,yM] = sampleminmax(yy,ii);
ii=ii(1:end-1)-.5;

x0 = xx(1);
dx = mean(diff(xx));

h = patch(x0+dx*[ii fliplr(ii)],[ym fliplr(yM)], 'b');
set(h,'edgec','none');

if lns
  h(2)=plot(x0+dx*ii,ym,'b');
  h(3)=plot(x0+dx*ii,yM,'b');
end

if nargout<1
  clear h
end
