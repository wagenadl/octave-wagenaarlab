function [vvv,pp]=voltprobe(ifn,wantinc,v0,dv,v1,xtick,ytick)
% [vvv,pp]=VOLTPROBE(ifn,wantinc,v0,dv,v1,xtick,ytick)
load(ifn);

T=length(tri.trg);
[chs,ser,nnn] = stmser(tri.trg);
vv = tri.trg(1:T-1,3);
V=max(vv);

chs=chs(1:T-1);
%   chs=zeros(T-1,1)+nan;
%   idx=tri.trg(1:T-1,3)>0 & tri.trg(1:T-1,4)>0;
%   chs(idx) = cr2hw(tri.trg(idx,3),tri.trg(idx,4));
S=60;
R=60;
THR=3; % Ignore trials with >= THR x elevated pre-activity

maxlat = median(diff(tri.tms))*1e3;
lat=spk.lat;
lat(lat>maxlat-200) = lat(lat>maxlat-200) - maxlat;

npost = hist(spk.tri(spk.lat>=5 & spk.lat<50),[1:T]);
npost = npost(1:T-1);
npre =  hist(spk.tri(lat<=-15 & lat>-65),[1:T]);
npre = npre(1:T-1);
medpre = median(npre);
avgpre = mean(npre);
qq=sort(npost);
mxy = max([qq(floor((T-1)*.8)) * 1.2, 5*avgpre]);

resp=zeros(S,V)+nan;
for s=1:S
  for v=1:V
    tidx = find(chs(:)==s-1 & vv(:)==v & npre(:)<THR*avgpre);
    ntri = length(tidx);
    if ntri>0
      resp(s,v) = mean(npost(tidx));
    end
  end
end

pp=zeros(S,2);
for s=1:S
  idx=find(~isnan(resp(s,:)));
  if length(idx)>2
    p=polyfit(idx,resp(s,idx),1);
    pp(s,:)=p(:)';
  else
    warning([ 'Cannot fit for CR=' num2str(hw2cr(s-1))]);
  end
end

figure(1); clf
ax = axes8x8;
S0=min([60 S]);
for s=1:S0
  axes(ax(s));
  plot(resp(s,:),'.');
  set(gca,'xtick',(xtick-v0)/dv+1);
  if hw2cr(s-1)==17
    set(gca,'xtickl',xtick);
  else
    set(gca,'xtickl',[]);
  end
  set(gca,'ytick',ytick*avgpre);
  if hw2cr(s-1)==28
    set(gca,'ytickl',ytick);
  else
    set(gca,'ytickl',[]);
  end
  hold on
  plot([1:V],[1:V]*0+avgpre,'g');
  plot([1:V],[1:V]*pp(s,1)+pp(s,2),'c');
  axis([.5 V+.5 0 mxy]);
  set(gca,'fontsize',7);
end

if S~=60
  warning([ 'Number of electrode marks not equal to 60: ' ...
	num2str(S) ]);
end

if nargin>=5
  vv=[v0:dv:v1]; VV=length(vv);
  if V-1~=VV
    warning([ 'Number of voltage marks not equal to ' num2str(VV) ...
	  ': ' num2str(V-1) ]);
  end
else
  warning([ 'Cannot tell whether number of voltage marks is OK: ' ...
	num2str(V-1) ]);
end

vvv=zeros(1,S);
for s=1:S
  % N = aV + b => V = (N-b) / a
  v = (avgpre*wantinc - pp(s,2)) / pp(s,1);
  axes(ax(s));
  plot(v,avgpre*wantinc,'r+');
  if nargin>=4
    fprintf(1,'Channel %i [%i]: %6.0f mV\n',...
	s-1, hw2cr(s-1), v0 + dv*(v-1));
    vvv(s) = v0 + dv*(v-1);
  else
    fprintf(1,'Channel %i [%i]: %6.2f steps\n',...
	s-1, hw2cr(s-1), v);
    vvv(s) = v;
  end
  a=axis; t=text(a(1)+(a(2)-a(1))*.05,a(3)+(a(4)-a(3))*.9,...
      sprintf('%.0f',vvv(s)));
  if v<1 | v>V | pp(s,1)<0
    set(t,'color',[.6 .6 .6]);
  end
end
