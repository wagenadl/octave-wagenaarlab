function bb=burstdet(times,t0,t1,dt,smo,thr)

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


figure(1); clf
rr=sort(zz); R=length(rr); rr=rr(ceil(R*.99));
xx=[0:rr/100:rr];
qq=hist(zz,xx);
qq(end)=0;
subplot(2,1,1);
plot(tt,zz);

subplot(2,1,2);
plot(xx,qq); 
hold on
[q0,x0]=max(qq);
par=fminsearch(@foo,[q0 1./xx(20)],[],[xx(x0:end)',qq(x0:end)']);
plot(xx,par(1)*exp(-par(2)*xx),'g-')
thr2=xx(min(find(qq>5*par(1)*exp(-par(2)*xx))));
if nargin<6
  thr=thr2;
  plot(thr,0,'r*');
else
  plot(thr2,0,'mo')
  plot(thr,0,'r*');
end
axis([0 rr 0 q0/10]);
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

xx = gaussianblur1d(yy,1);
xx(1)=0; xx(end)=0;

mm = mean(xx);
K=length(bb.start);
bb.onset = nan+bb.start;
bb.offset = nan+bb.end;

for k=1:K
  ww=xx(regstart(k):regend(k));
  mx = max(ww);
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

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function chi2=foo(par,xx)
nn=xx(:,1);
cc=xx(:,2);
cc0 = par(1)*exp(-nn.*par(2));
chi2 = sum((cc-cc0).^2);
