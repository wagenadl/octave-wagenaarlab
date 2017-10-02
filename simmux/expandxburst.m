function ss=expandxburst(ss,mm,kk,usemon)
% ss=EXPANDXBURST(ss,mm) expands the superbursts in SS with all bursts
% in MM that lie with their domain.

if nargin<3 | isempty(kk)
  kk=bigxburst(mm);
end

if nargin<4 | isempty(usemon)
  usemon=0;
end

if usemon==1
  mm.onset=mm.monset;
  mm.offset=mm.moffset;
elseif usemon==2
  mm.onset=mm.qonset;
  mm.offset=mm.qoffset;
end


facthr=1;
M=length(mm.onset);
S=length(ss.onset);
for s=1:S
  N=length(ss.constit{s});
  avgibi = mean(mm.offset(ss.constit{s}(2:N))-mm.onset(ss.constit{s}(1:N-1)));
  first = ss.constit{s}(1);
  st=ss.onset(s);
  while first>1 & mm.offset(first-1)>st-facthr*avgibi
    first=first-1;
    if find(kk==first)
      st=min(st,mm.onset(first));
    end
    ss.constit{s}=[ss.constit{s}; first];
  end
  last = ss.constit{s}(1);
  en=ss.offset(s);
  while last<M & mm.onset(last+1)<en+facthr*avgibi
    last=last+1;
    if find(kk==last)
      en=max(en,mm.offset(last));
    end
    if isempty(find(ss.constit{s}==last))
      ss.constit{s}=[ss.constit{s}; last];
    end
  end
  ss.onset(s) = min(mm.onset(ss.constit{s}));
  ss.offset(s) = max(mm.offset(ss.constit{s}));
  ss.nsub(s) = length(ss.constit{s});
  ss.nbig(s) = 0;
  for k=ss.constit{s}(:)'
    if find(kk==k)
      ss.nbig(s)=ss.nbig(s)+1;
    end
  end
  ss.netspks(s) = sum(mm.netspks(ss.constit{s}));
  ss.totdur(s) = sum(mm.offset(ss.constit{s})-mm.onset(ss.constit{s}));
end

