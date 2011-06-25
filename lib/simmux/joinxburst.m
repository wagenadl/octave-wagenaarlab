function mmm=joinxburst(mm,bb)
% mm=JOINXBURST(mm,bb) joins multix bursts in mm that are separated by
% less than the average constituent duration in the first of pairs.

mmm.onset=[];
mmm.offset=[];
mmm.cmap=[];
mmm.cc=[];
mmm.cspks=[];
mmm.netspks=[];
mmm.good=[];
mmm.constit={};

minm=0;
o=0;
M=length(mm.onset);
for m=1:M
  if m<minm
    continue;
  end
  o=o+1;
  mmm.onset(o)   = mm.onset(m);
  mmm.offset(o)  = mm.offset(m);
  mmm.cmap(o,:)  = mm.cmap(m,:);
  mmm.cc(o)      = mm.cc(m);
  mmm.cspks(o,:) = mm.cspks(m,:);
  mmm.netspks(o) = mm.netspks(m);
  mmm.good(o)    = mm.good(m);
  mmm.constit{o,1} = mm.constit{m};

  avgdur = mean(bb.offset(mmm.constit{o})-bb.onset(mmm.constit{o}));
  n=m+1;
  while n<=M & mm.onset(n)-mmm.offset(o) < avgdur
    dt=mm.onset(n)-mmm.offset(o);
    minm=n+1;
    mmm.offset(o) = max(mmm.offset(o),mm.offset(n));
    mmm.cmap(o,:)  = mmm.cmap(o,:)  + mm.cmap(n,:);
    mmm.cc(o)      = sum(mmm.cmap(o,:)>0,2);
    mmm.cspks(o,:) = mmm.cspks(o,:) + mm.cspks(n,:);
    mmm.netspks(o) = mmm.netspks(o) + mm.netspks(n);
    mmm.good(o)    = mmm.good(o)    + mm.good(n);
    mmm.constit{o,1} = [mmm.constit{o}; mm.constit{n}];
    n=n+1;
  end
end

mmm.onset=mmm.onset(:);
mmm.offset=mmm.offset(:);
mmm.netspks=mmm.netspks(:);
mmm.good=mmm.good(:);
