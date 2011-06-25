function [bb,co]=simplexburst(tms,chs,dt_max,n_min,dt_min,frthr_min,frthr_max,n_min_min,msg)
% bb=SIMPLEXBURST(tms,chs,dt_max,n_min,dt_min) finds single channel bursts
% within the dataset (TMS,CHS), where a single channel burst is a
% spike train on one channel, consisting of at least N_MIN spikes,
% with ISI less than DT_MAX between each pair, together with the
% surrounding spikes until one ISI is larger than DT_MIN.
%
% Return: a structure with members:
%
%  Bx1  ONSET: start time
%  Bx1  OFFSET: end time
%  Bx1  NSPIKES: number of spikes
%  Bx1  CHANNEL: channel on which the spike occurs
%  Bx1  TMEAN: avg. of spike times
%  Bx1  STDDUR: std.dev. of spike times
%  Bx1  GOOD: does this burst really have the central peak?
%  Bx1  DTPRE: ISI before burst
%  Bx1  DTPOST: ISI after burst
%
% Additional arguments with sensible defaults:
%
%  FRTHR_MIN: min. FR during burst relative to avg. FR of this channel
%  FRTHR_MAX: min. FR during burst center relative to avg. FR of this channel
%  N_MIN_MIN: min. # of spikes in entire burst
%
% [bb,co]=SIMPLEXBURST(...) also returns a array of burst indices
% for all spikes.

if nargin<3 | isempty(dt_max)
  dt_max = 0.050;
end
if nargin<4 | isempty(n_min)
  n_min = 5;
end
if nargin<5 | isempty(dt_min)
  dt_min = 0.200;
end
if nargin<6 | isempty(frthr_min)
  frthr_min = 1e-9; %%% was: 1.5;
end
if nargin<7 | isempty(frthr_max)
  frthr_max = 1e-9; %%% was: 3;
end
if nargin<8 | isempty(n_min_min)
  n_min_min = n_min;
end
if nargin<9
  msg='';
end

if nargout>=2
  co = zeros(size(tms));
end

n_min_min = max(n_min_min,n_min);

tms=tms(:);
chs=chs(:);
HW = max(chs);

bb.dt_max = dt_max;
bb.n_min = n_min;
bb.dt_min = dt_min;
bb.frthr_min = frthr_min;
bb.frthr_max = frthr_max;
bb.n_min_min = n_min_min;
bb.msg=msg;

bb.onset=zeros(0,1);
bb.offset=zeros(0,1);
bb.nspikes=zeros(0,1);
bb.channel=zeros(0,1);
bb.tmean=zeros(0,1);
bb.stddur=zeros(0,1);
bb.good=zeros(0,1);
bb.dtpre=zeros(0,1);
bb.dtpost=zeros(0,1);

for hw=0:HW
  if HW
    fprintf(1,'%s (hw=%2i)\r',msg,hw);
    id=find(chs==hw);
    if isempty(id)
      continue
    end
    [tt,oo]=sort(tms(id));
  else
    [tt,oo]=sort(tms);
  end
  oo(oo)=[1:length(oo)];
  dt=diff(tt);
  if isempty(dt)
    continue
  end
  avgisi=mean(dt);
  dt=[inf; dt; inf];
  
  cand=dt<min(dt_min,avgisi/frthr_min);
  sten=[0; diff(cand)];
  starts=find(sten>0)-1;
  ends=find(sten<0);
  len=ends-starts;
  long=find(len>=n_min_min);
  if ~isempty(long)
    L=length(long);
    ons=zeros(L,1);
    ofs=zeros(L,1);
    dtpr=zeros(L,1);
    dtpo=zeros(L,1);
    nsp=zeros(L,1);
    tmn=zeros(L,1);
    tsd=zeros(L,1);
    good=logical(zeros(L,1));
    g0=length(bb.onset);
    for g=1:L
      ons(g)=tt(starts(long(g)));
      ofs(g)=tt(ends(long(g))-1);
      dtpr(g)=dt(starts(long(g)));
      dtpo(g)=dt(ends(long(g)));
      ii=[starts(long(g)):ends(long(g))-1];
      dt2=[inf; diff(tt(ii)); inf];
      cand2=dt2<min(dt_max,avgisi/frthr_max);
      sten2=[0; diff(cand2)];
      starts2=find(sten2>0);
      ends2=find(sten2<0);
      len2=ends2-starts2;
      long2=find(len2>=n_min);
      good(g)=~isempty(long2);
      nsp(g)=length(ii);
      tmn(g)=mean(tt(ii));
      tsd(g)=std(tt(ii));
%      if nargout>=2
%	co(id(oo(ii)))=g0+g;
%      end
    end
    bb.onset=[bb.onset; ons];
    bb.offset=[bb.offset; ofs];
    bb.dtpre=[bb.dtpre; dtpr];
    bb.dtpost=[bb.dtpost; dtpo];
    bb.nspikes=[bb.nspikes; nsp];
    bb.channel=[bb.channel; repmat(hw,L,1)];
    bb.tmean=[bb.tmean; tmn];
    bb.stddur=[bb.stddur; tsd];
    bb.good=[bb.good; 0.0+good];
  end
end

[bb.onset, ord]=sort(bb.onset);
bb.offset=bb.offset(ord);
bb.nspikes=bb.nspikes(ord);
bb.channel=bb.channel(ord);
bb.tmean=bb.tmean(ord);
bb.stddur=bb.stddur(ord);
bb.good=logical(bb.good(ord));

inv(ord)=[1:length(ord)];
if nargout>=2
  co(co>0)=inv(co(co>0));
end

if HW>0
  fprintf(1,'\n');
end