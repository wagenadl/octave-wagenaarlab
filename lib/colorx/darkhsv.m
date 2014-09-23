function cc=darkhsv(n,d)
% cc=DARKHSV(n,d) returns a hsv-like colormap, but darkened to D (try D=0.3).

if nargin<2
  d=.3;
end

phi=[1:n]'*2*pi/n;

cc = [cos(phi),cos(phi+2*pi/3),cos(phi+4*pi/3)]/2+.5;
gry = (cc(:,1)*2 + cc(:,2)*3 + cc(:,3)) / 6;
cc = cc.* repmat(d./gry,[1 3]);
dc = cc ./ repmat(mean(cc,2),[1 3]);
cc = cc .* dc.^.5;
cc(cc>1)=1;
cc(cc<0)=0;


