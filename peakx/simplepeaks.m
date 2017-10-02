function pk=simplepeaks(yy,y0,thr,base)

if nargin<3 | isempty(thr)
  thr=.25;
end
if nargin<4 | isempty(base)
  base=mean(yy);
end

yy1 = [ 0 0 yy];
yy2 = [ 0 yy 0];
yy3 = [ yy 0 0];
idx = find(yy2>yy1 & yy2>=yy3 & yy2>=y0) - 1;

N=length(idx);
starts=0*idx+1;
ends=0*idx+N;
peaks=yy(idx);
for n=1:N
  left = find(yy(1:idx(n))<thr*yy(idx(n)));
  if ~isempty(left)
    starts(n) = max(left)+1;
  end
  right = find(yy(idx(n):end)<thr*yy(idx(n))) + idx(n)-1;
  if ~isempty(right)
    ends(n) = min(right)-1;
  end
end
lose=1;
while lose>0
  N=length(peaks);
  lose=0;
  good=logical(ones(1,N));
  for n=2:N
    if starts(n)<ends(n-1)
      if peaks(n)>peaks(n-1)
        good(n-1)=0;
      else
        good(n)=0;
      end
      lose=1;
    end
  end
  
  starts=starts(good);
  ends=ends(good);
  peaks=peaks(good);
  idx=idx(good);
end

st0=0*starts + 1;
en0=0*ends + length(yy);
for n=1:N
  left = find(yy(1:idx(n))<base);
  if ~isempty(left)
    st0(n) = max(left)+1;
  end
  right = find(yy(idx(n):end)<base) + idx(n)-1;
  if ~isempty(right)
    en0(n) = min(right)-1;
  end
end
for n=2:N
  [mn,id] = min(yy(idx(n-1):idx(n)));
  id = id + idx(n-1)-1;
  en0(n-1) = min([en0(n-1) id]);
  st0(n) = max([st0(n) id]);
end

for n=[1:N]
  l=line([st0(n) en0(n)],[0 0]+peaks(n)/2);
  set(l,'color',[1 .5 .5]);
end

pk.pos = idx;
pk.height = peaks;
pk.onset = st0;
pk.offset = en0;
