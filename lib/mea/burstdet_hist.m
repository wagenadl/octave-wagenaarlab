function y = superburstdet(tms, bin_ms, smooth_bins, thr_median, plotflag)

if nargin<5 | isempty(plotflag)
  plotflag=0;
end

if nargin<4 | isempty(thr_median)
  thr_median=4;
end

if nargin<3 | isempty(smooth_bins)
  smooth_bins=3;
end

if nargin<2 | isempty(bin_ms)
  bin_ms = 0.010;
end

T0 = min(tms)-1;
T1 = max(tms)+1;

[zz,tt] = hist(tms,[T0:bin_ms:T1]);
yy = gaussianblur1d(zz,smooth_bins) / bin_ms;
N=length(yy);
yy(1)=0;  yy(N)=0;
thr = thr_median * median(yy);

inburst = yy>thr;
din = diff(inburst);
regstart = 1 + find(din>0);
regend = 1 + find(din<0);

y.start=tt(regstart);
y.end=tt(regend);
y.dur=y.end-y.start;

xx = gaussianblur1d(zz,1) / bin_ms;
xx(1)=0; xx(N)=0;

mm = mean(xx);
K=length(y.start);
y.onset = 0*y.start;
y.offset = 0*y.end;
for k=1:K
  ww=xx(regstart(k):regend(k));
  mx = max(ww);
  id = min(find(ww>mm + (mx-mm)*.25));
  y.onset(k) = tt(id-1+regstart(k));
  
  id = max(find(ww>mm + (mx-mm)*.25));
  y.offset(k) = tt(id-1+regstart(k));
end
  

if plotflag
  figure(2); clf
  plot(tt,yy);
  hold on
  plot(y.start,thr,'r.');
  plot(y.end,thr,'g.');
  plot(y.onset,thr*2,'r.');
  plot(y.offset,thr*2,'g.');
  xlabel 'Time (s)'
  ylabel 'Aggregate firing rate (spikes/s)'
  title 'Bursts'
end

N=length(regstart);
count=0*y.start;
for n=1:N
  count(n) = sum(zz(regstart(n):regend(n)-1));
end
y.count=count;

dt = [1000 diff(y.start)];
ww= y.end-y.start;

if plotflag
  figure(3)
  subplot(2,1,1)
  semilogx(dt+rand(1,N)*0.05,count+rand(1,N),'.')
  xlabel 'Time before burst (s)'
  ylabel 'Spikes in burst (all channels)'
  title 'Count statistics'
  subplot(2,1,2)
  semilogx(dt+rand(1,N)*0.05,ww+rand(1,N)*0.05,'.')
  xlabel 'Time before burst (s)'
  ylabel 'Duration of burst (s)'
  title 'Duration statistics'
  
  figure(4); clf
  ii=find(dt>10);
  jj=find(dt<10);
  plot(ww(ii)+rand(1,length(ii))*.05,count(ii),'.r', ww(jj)+rand(1,length(jj))*.05,count(jj),'.b');
  legend('First in super','Others')
  xlabel 'Duration of burst (s)'
  ylabel 'Spikes in burst (all channels)'
  title 'Counts & durations'
end
