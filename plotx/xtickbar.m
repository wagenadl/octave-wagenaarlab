function h=xtickbar(xx,y,ticklen,lbls,ttl,edg)
% h=XTICKBAR(xx,y,ticklen,lbls,ttl,edg) draws a single x-axis.
% TICKLEN is in inches!
% See TICKBAR for more details.

if nargin<6
  edg=[];
end

[lx,ly] = oneinch;
h=tickbar(xx,y,ticklen*ly,lbls,ttl,edg);

