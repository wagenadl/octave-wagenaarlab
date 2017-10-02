function mmm=disjoinxburst(mm,bb,tms,chs,plotflag)
% nn = DISJOINXBURST(mm,bb,tms,chs) disjoins multixbursts in MM, based on 
% dips in the number of active channels over time.

if nargin<5 | isempty(plotflag)
  plotflag=0;
end

C = max(bb.channel)+1;

havegon=isfield(mm,'gonset');

mmm.onset=zeros(0,1);
mmm.offset=zeros(0,1);
mmm.cmap=zeros(0,C);
mmm.gmap=zeros(0,C);
mmm.cc=zeros(0,1);
mmm.cspks=zeros(0,C);
mmm.netspks=zeros(0,1);
mmm.good=zeros(0,1);
mmm.constit=cell(0,1);
mmm.monset=zeros(0,1);
mmm.moffset=zeros(0,1);
if havegon
  mmm.gonset=zeros(0,1);
  mmm.goffset=zeros(0,1);
end
k=0;
M=length(mm.onset);

dt=0.050;

for m=1:M
  if mod(m,100)==0
    fprintf(1,' (disjoinx-1: %i/%i)       \r',m,M);
  end
  t0=mm.onset(m);
  t1=mm.offset(m);
  tt=[t0:dt:t1];
  yy=0*tt;
  B=length(mm.constit{m});
  for b=1:B
    ib=mm.constit{m}(b);
    rng=[1+floor((bb.onset(ib)-t0)/dt):1+floor((bb.offset(ib)-t0)/dt)];
    yy(rng)=yy(rng)+1;
  end
  
  [pk,dp] = peakdip(yy,5,2,0);
  N=length(pk);
  if N>0
    centroid=tt(pk); 
  else
    centroid=mean(tt);
    N=1;
  end
  burstcen=(bb.onset(mm.constit{m})+bb.offset(mm.constit{m}))/2;
  dist=repmat(centroid,B,1) - repmat(burstcen,1,N);
  [dd,assign]=min(dist.^2,[],2);  
  
  if length(mmm.onset)<k+30
    mmm.onset=[mmm.onset; zeros(100,1)];
    mmm.offset=[mmm.offset; zeros(100,1)];
    mmm.monset=[mmm.monset; zeros(100,1)];
    mmm.moffset=[mmm.moffset; zeros(100,1)];
    mmm.cmap=[mmm.cmap; zeros(100,C)];
    mmm.gmap=[mmm.gmap; zeros(100,C)];
    mmm.cspks=[mmm.cspks; zeros(100,C)];
    mmm.good=[mmm.good; zeros(100,1)];
    if havegon
      mmm.gonset=[mmm.gonset; zeros(100,1)];
      mmm.goffset=[mmm.goffset; zeros(100,1)];
    end      
  end
  for n=1:N
    mine=find(assign==n);
    if ~isempty(mine)
      midx=mm.constit{m}(mine);
      gidx=midx(find(bb.good(midx)));
      if isempty(gidx)
	continue
      end
      k=k+1;
      mmm.onset(k,1) = min(bb.onset(gidx));
      mmm.offset(k,1) = max(bb.offset(gidx));
      mmm.monset(k,1) = mean(bb.onset(gidx));
      mmm.moffset(k,1) = mean(bb.offset(gidx));
      if havegon
	mmm.gonset(k,1) = mm.gonset(m);
	mmm.goffset(k,1) = mm.goffset(m);
      end
      mmm.cmap(k,:) = hist(bb.channel(midx),[0:C-1]);
      mmm.gmap(k,:) = hist(bb.channel(gidx),[0:C-1]);
      mmm.cspks(k,:) = zeros(1,C);
      for b=midx(:)'
	mmm.cspks(k,bb.channel(b)+1)=mmm.cspks(k,bb.channel(b)+1)+bb.nspikes(b);
      end
      mmm.constit{k,1} = midx(:);
      mmm.good(k,1)=length(gidx);
    end
  end
end

mmm.onset=mmm.onset(1:k);
mmm.offset=mmm.offset(1:k);
mmm.monset=mmm.monset(1:k);
mmm.moffset=mmm.moffset(1:k);
if havegon
  mmm.gonset=mmm.gonset(1:k);
  mmm.goffset=mmm.goffset(1:k);
end
mmm.good=mmm.good(1:k);
mmm.cmap=mmm.cmap(1:k,:);
mmm.gmap=mmm.gmap(1:k,:);
mmm.cspks=mmm.cspks(1:k,:);
mmm.cc=sum(mmm.cmap>0,2);
mmm.gg=sum(mmm.gmap>0,2);
mmm.netspks=sum(mmm.cspks,2);

mmm.qonset=mmm.onset; 
mmm.qoffset=mmm.offset; 
N=length(mmm.onset);
for n=1:N
  if mod(n,100)==0
    fprintf(1,' (disjoinx-2: %i/%i)   \r',n,N);
  end
  bidx=mmm.constit{n};
  bon=bb.onset(bidx);
  bof=bb.offset(bidx);
  son=sort(bon);
  sof=sort(bof);
  L=max(length(son),2);
  mmm.qonset(n) = son(ceil(.25*L));
  mmm.qoffset(n) = sof(floor(.75*L));
end

if nargin>=4 & ~isempty(tms)
  [mmm.comap,mmm.frbase] = comapx(mmm,tms,chs);
  mmm.co = sum(mmm.comap>3,2);
  mmm.totspks = (mmm.comap.*(mmm.comap>3)) * mmm.frbase';
else
  mmm.frbase=zeros(1,60)+nan;
  mmm.comap=mmm.cmap+nan;
  mmm.co=mmm.cc+nan;
  mmm.totspks = mmm.netspks+nan;
end
