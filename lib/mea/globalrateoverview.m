function globalrateoverview(spikefn,period,ttl)

if nargin<2 | isempty(period)
  period = 1000;
end

if nargin<3 | isempty(ttl)
  ttl=spikefn;
end

spk = loadspike_noc(spikefn,3);

idx=find(spk.channel<60);
t0=min(spk.time(idx));

tms = spk.time(idx)-t0;

clear spk

t1 = max(tms);

P = ceil(t1/period);
Q=max([P 3]);

fprintf(2,'File: %s. start: %g. length: %g. P=%g\n',spikefn,t0,t1,P);

clf
ax=zeros(1,P);
mx=zeros(1,P);
for p=1:P
  fprintf(2,'p=%i. Time: %g-%g ...\n', p, period*(p-1), period*p);
  ax(p)=axes('position',[0.1 .95-.93*p/Q .88 .88/Q]);
  idx=find(tms>=period*(p-1) & tms<period*p);
  fprintf(2,'  %i spikes\n',length(idx));
  x=[period*(p-1):.5:period*p];
  y=hist(tms(idx),x);
  b=plot(x,y/.5); % set(b,'edgec','none');
  fprintf(2,'  Histogram plotted\n');
  a=axis;
  mx(p)=a(4);
  set(gca,'xtick',[0:60:period*P]);
  set(gca,'xticklabel',[]);
  yt=get(gca,'ytick');
  set(gca,'ytick',yt);
  L=length(yt);
  ytl=cell(1,L);
  for l=1:L-1
    ytl{l} = num2str(yt(l));
  end
  set(gca,'yticklabel',ytl);
  if p==1
    title(ttl);
  end
end
for p=1:P
  set(ax(p),'xlim',[period*(p-1) period*p]);
  set(ax(p),'ylim',[0 max(mx)]);
end
