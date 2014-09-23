function cc=darkjet(n,d)
% cc=DARKJET(n,d) returns a JET-like colormap, but darkened to D (try D=0.6).

if nargin<2
  d=.3;
end

cc=jet(n);
gry = (cc(:,1)*2 + cc(:,2)*3 + cc(:,3)) / 6;
cc = cc.* repmat(tanh(d./gry),[1 3]);
dc = cc - repmat(mean(cc,2),[1 3]);
cc = cc + dc;
cc(cc>1)=1;
cc(cc<0)=0;


