function bb=burstdet2(times,t0,t1,dt,smo,thr,smo2)
% bb=BURSTDET2(times,t0,t1,dt,smo,thr,smo2) detects (global) bursts.
% Input: TIMES: spike times, in seconds
%        T0,T1: start and end of episode to consider (s)
%        DT: bin size (sliding window time step) (s)
%        SMO: smoothing factor (sliding window halfwidth is DT*SMO)
%        THR: threshold for burst detection, or [] for automatic
%        SMO2: smoothing factor for refinement.
% THR and SMO2 are optional.
%
% Output: structure with members
%
% START: start times of bursts (s) (unrefined)
% END:   end times of bursts (s) (unrefined)
% ONSET: start times of bursts (s) (refined)
% OFFSET: end times of bursts (s) (refined)
%
% Bursts are defined as a contiguous region in the SMO-smoothed
% histogram during which the global firing rate exceeds THR. If THR is
% not specified, it is computed as follows:
%
%   - Construct a histogram of firing rates
%   - Fit a function of the form: y = a * x * exp(-b * sqrt(x)) to the
%     part of the histogram right of its peak.
%   - Find the first bin in which the real histogram exceeds the fit
%     function.
%
% (Note that the functional form was chosen by trying various options.
% There is no theoretical significance to it. BURSTDET2 creates a plot
% showing the histogram and the threshold obtained from it.)
%
% Subsequently, for each burst thus obtained, a SMO2-smoothed firing
% rate plot is created. "Refined" start and end times are obtained as
% the first and last bins in this plot where the firing rate exceeds
% the threshold.

if isempty(t0)
  t0=min(times)-.5;
end
if isempty(t1)
  t1=max(times)+.5;
end
tt=[t0:dt:t1];
yy=hist(times,tt)/dt;
yy(1)=0; yy(end)=0;                                          
zz=gaussianblur1d(yy,smo);

if nargin<7 | isempty(smo2)
  smo2 = 1;
end

figure(1); clf
%rr=sort(zz); R=length(rr); rr=rr(ceil(R*.99));
%xx=[0:rr/100:rr];
subplot(2,1,1);
plot(tt,zz);
xlabel 'Time (s)'
ylabel 'Global spike rate (Hz)'

rr=median(zz);
xx=[0:rr/2:rr*50];
qq=hist(zz,xx);
qq(end)=0;

keyboard

subplot(2,1,2);
plot(xx,qq,'b.-'); 
xlabel 'Global spike rate (Hz)'
ylabel 'Number of bins'
hold on
[q0,x0]=max(qq);
x0=max([x0 2]);
par=fminsearch(@foo,[q0 1./xx(20)],[],[xx(x0:end)',qq(x0:end)']);
plot(xx,par(1)*xx.*exp(-par(2)*xx.^.5),'g-')
en=50;
thr2=xx(max(find(qq(1:en)<par(1)*xx(1:en).*exp(-par(2)*xx(1:en).^.5))));
if nargin<6 | isempty(thr)
  thr=thr2;
  plot(thr,0,'r*');
else
  plot(thr2,0,'mo')
  plot(thr,0,'r*');
end
axis([0 max([rr*10 2*thr]) 0 q0/5]);
drawnow

bb.thr =thr;

zz(1)=0; zz(end)=0;
inburst = zz>thr;
din = diff([0 inburst]);
regstart = find(din>0);
regend = find(din<0);


bb.start=tt(regstart);
bb.end=tt(regend);
bb.dur=bb.end-bb.start;

xx = gaussianblur1d(yy,smo2);
xx(1)=0; xx(end)=0;

mm = mean(xx);
K=length(bb.start);
bb.onset = nan+bb.start;
bb.offset = nan+bb.end;

for k=1:K
  ww=xx(regstart(k):regend(k));
  %  mx = max(ww);
  %  thth = mm + (mx-mm)*.25;
  thth = thr;
  id = min(find(ww>thr));
  if ~isempty(id)
    bb.onset(k) = tt(id-1+regstart(k));
    id = max(find(ww>thth));
    bb.offset(k) = tt(id-1+regstart(k));
  end
end

figure(1); 
subplot(2,1,1); hold on
plot(tt,xx,'y');
plot(bb.start,thr,'r.');
plot(bb.end,thr,'g.');
plot(bb.onset,thr*2,'r.');
plot(bb.offset,thr*2,'g.');
drawnow
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function chi2=foo(par,xx)
nn=xx(:,1);
cc=xx(:,2);
cc0 = par(1)*nn.*exp(-nn.^.5.*par(2));
chi2 = sum((cc-cc0).^2);
