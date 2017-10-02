function mm=multixburst(bb,badalso)
% mm=MULTIXBURST(bb) finds all sets of overlapping simplexbursts in
% BB, and marks them as multi-channel, or "multix" bursts.
% There is no special cleverness in this code, so it is pretty slow.
% If a second non-zero argument is given, all multices are returned,
% otherwise, only those with at least one "good" constituent.
%
% Output: structure with members:
%
%  Mx1  ONSET:   onset times of multices, i.e. onset of first constituent
%  Mx1  OFFSET:  offset times of multices, i.e. onset of last ending
%      	         constituent
%  MxC  CMAP:    map of participating channels (number of simplices on each)
%  Mx1  CC:      total number of participating channels
%  MxC  CSPKS:   per-channel number of spikes
%  Mx1  NETSPKS: total number of spikes in participating channels
%  Mx1  GOOD:    count of number of "good" simplex bursts in each multix
% {Mx1} CONSTIT: list of constituent simplices.


C=max(bb.channel)+1;

if nargin<2 | isempty(badalso)
  badalso=0;
end

mm.onset=[];
mm.offset=[];
mm.cmap=[];
mm.cc=[];
mm.cspks=[];
mm.netspks=[];
mm.good=[];
mm.constit={};

M=0;
B=length(bb.onset);
lastof=-inf;
t0=min(bb.onset);
t1=max(bb.offset);
for b=1:B
  if bb.onset(b)>lastof
    if M>0 & mm.good(M)
      fprintf(1,' (multixburst: %i%%)\r',ceil((100*(lastof-t0)/(t1-t0))));
    end
    if length(mm.onset)<M+30
      mm.onset=[mm.onset; zeros(100,1)];
      mm.offset=[mm.offset; zeros(100,1)];
      mm.cmap=[mm.cmap; zeros(100,C)];
      mm.cspks=[mm.cspks; zeros(100,C)];
      mm.good=[mm.good; zeros(100,1)];
    end
    M=M+1;
    mm.onset(M)=bb.onset(b);
    mm.cmap(M,1:C)=zeros(1,C); 
    mm.cspks(M,1:C)=zeros(1,C); 
    mm.constit{M,1}=[];
    mm.good(M)=0;
  end
  lastof=max(lastof, bb.offset(b));
  mm.offset(M)=lastof;
  mm.good(M)=mm.good(M)+bb.good(b);
  mm.cmap(M,bb.channel(b)+1)=mm.cmap(M,bb.channel(b)+1) + 1;
  mm.cspks(M,bb.channel(b)+1)=mm.cspks(M,bb.channel(b)+1) + bb.nspikes(b);
  mm.constit{M,1}=[mm.constit{M}; b];
end

mm.onset=mm.onset(1:M);
mm.offset=mm.offset(1:M);
mm.good=mm.good(1:M);
mm.cmap=mm.cmap(1:M,:);
mm.cspks=mm.cspks(1:M,:);

mm.onset=mm.onset(:);
mm.offset=mm.offset(:);
mm.cc=sum(mm.cmap>0,2);
mm.netspks=sum(mm.cspks,2);
mm.good=mm.good(:);

if ~badalso
  gd=find(mm.good>0);
  mm.onset=mm.onset(gd);
  mm.offset=mm.offset(gd);
  mm.cc=mm.cc(gd);
  mm.netspks=mm.netspks(gd);
  mm.good=mm.good(gd);
  mm.cmap=mm.cmap(gd,:);
  mm.cspks=mm.cspks(gd,:);
  
  G=length(gd);
  tmp=cell(G,1);
  for g=1:G
    tmp{g}=mm.constit{gd(g)};
  end
  mm.constit=tmp;
end

M=length(mm.onset);
mm.monset=mm.onset;
mm.moffset=mm.offset;
for m=1:M
  mm.monset(m)=mean(bb.onset(mm.constit{m}));
  mm.moffset(m)=mean(bb.offset(mm.constit{m}));
end

if isempty(mm.cmap)
  mm.cmap=zeros(0,60);
end
if isempty(mm.cspks)
  mm.cspks=zeros(0,60);
end

fprintf(1,'\n');
