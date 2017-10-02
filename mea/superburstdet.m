function y = superburstdet(tms,thr_super_median,thr_regular_median)

if nargin<3
  thr_regular_median = 4
end
if nargin<2
  thr_super_median = 4
end


T0 = min(tms)-1;
T1 = max(tms)+1;

% First stage, locate superbursts:

[yy,tt] = hist(tms,[T0:.5:T1]);
yy = gaussianblur1d(yy,3) / 0.5;
N=length(yy);
yy(1)=0;  yy(N)=0;

thr = thr_super_median * median(yy);

inburst = yy>thr;
din = diff(inburst);
superstart = 1 + find(din>0);
superend = 1 + find(din<0);

y.superstart = tt(superstart);
y.superend = tt(superend);

figure(1); clf
plot(tt,yy);
hold on
plot(y.superstart,thr,'r.');
plot(y.superend,thr,'g.');
xlabel 'Time (s)'
ylabel 'Aggregate firing rate (spikes/s)'
title 'Superbursts'

% Second stage, locate ordinary bursts

[zz,tt] = hist(tms,[T0:.05:T1]);
yy = gaussianblur1d(zz,3) / 0.05;
N=length(yy);
yy(1)=0;  yy(N)=0;
thr = thr_regular_median * median(yy);

inburst = yy>thr;
din = diff(inburst);
regstart = 1 + find(din>0);
regend = 1 + find(din<0);

y.regstart=tt(regstart);
y.regend=tt(regend);

figure(2); clf
plot(tt,yy);
hold on
plot(y.regstart,thr,'r.');
plot(y.regend,thr,'g.');
xlabel 'Time (s)'
ylabel 'Aggregate firing rate (spikes/s)'
title 'Regular bursts'


N=length(regstart);
count=0*y.regstart;
for n=1:N
  count(n) = sum(zz(regstart(n):regend(n)-1));
end
y.regcount=count;

dt = [1000 diff(y.regstart)];
ww= y.regend-y.regstart;

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

