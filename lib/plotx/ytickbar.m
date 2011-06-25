function h=xtickbar(yy,x,ticklen,lbls,ttl,edg)
% h=YTICKBAR(yy,x,ticklen,lbls,ttl,edg) draws a single y-axis.
%TICKLEN is in inches!
% See TICKBAR for more details.

if nargin<6
  edg=[];
end

[lx,ly] = oneinch;
h=tickbar(x,yy,ticklen*lx,lbls,ttl,edg);

