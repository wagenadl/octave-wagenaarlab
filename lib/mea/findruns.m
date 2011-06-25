function rr=findruns(times, channels, bin_ms, smooth_bins, thr)

T0=min(times)-1;
T1=max(times)+1;
tt=[T0:(bin_ms/1000):T1];

yy=histc(times,tt);
if nargin<5
  med = mean(yy);
  if med<2
    fprintf(2,'Warning from findruns: mean is %.2f < 2.\n',med);
  end
  thr = med;
end

rr.threshold = thr;

yy=gaussianblur1d(yy(:)',smooth_bins);


yy(1)=0; yy(length(yy))=0;

inrun = yy>thr;

edge = [0 diff(inrun)];
bstart = find(edge>0);
bend = find(edge<0);
rr.start = tt(bstart);
rr.end = tt(bend);

rr.duration = rr.end-rr.start;

N=length(rr.start);
rr.nspike = zeros(1,N);
rr.nchan = zeros(1,N);
for n=1:N
  idx = find(times>=rr.start(n) & times<rr.end(n));
  rr.nspike(n)=length(idx);
  chmap=zeros(1,60);
  chmap(channels(idx)+1)=1;
  rr.nchan(n) = sum(chmap);
end
  
  