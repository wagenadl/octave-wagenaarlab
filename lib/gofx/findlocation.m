function findlocation(expt,intgfn)
% FINDLOCATION - Manually determine the location of contraction/expansion
%    FINDLOCATION(expt) or FINDLOCATION(logfn,intgfn) opens a window
%    with contraction/relaxation curves, which allows you to determine
%    the location of maximum contraction/relaxation on the ipsi/contralateral
%    side of the poke.
%    The result must be manually saved in orig/region_EXPT.m, which contains:
%
%      xcontra = [leftx rightx];
%      xipsi = [leftx rightx];
if nargin==1
  expt=strtoks(expt);
  if length(expt)==1
    run(sprintf('orig/log_%s.m',expt{1}));
    load(sprintf('ana/intg40-%s.mat',expt{1}));
  else
    run(expt{1});
    load(expt{2});
  end
else
  run(expt);
  load(intgfn);
end

N=length(fileno);
X=size(contr,1);
xx=[1:X];

logf = log(forces);
logf(forces<=0)=log(.1);
logf(isnan(forces))=log(.1);
lfm = min(logf);
lfM = max(logf);
if lfM > lfM
  cidx = ceil(1000*(logf-lfm)./(lfM-lfm))+1;
else
  cidx = ceil(1000*[1:N]/N);
end

c_bmi=1-[0:.001:1]'*[0 1 1];
c_sal=1-[0:.001:1]'*[1 1 0];

thr=2;

figure(1); clf; hold on
for n=1:N
  f=fileno(n);
  if setno(n)>0
    if isbmi(n)
      clr=c_bmi(cidx(n),:);
    else
      clr=c_sal(cidx(n),:);
    end
    yy=contr(:,f);
    dy1=[0;diff(yy)];
    dy2=[diff(yy);0];
    bad=find(abs(dy1)>thr | abs(dy2)>thr);
    yy(bad)=nan;
    plot(xx,yy,'color',clr);
  end
end
axis tight
if X==151
  a=axis;
  for x=[51 101]
    plot([x x],a(3:4),'k:');
  end
end
