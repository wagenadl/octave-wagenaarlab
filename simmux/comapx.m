function [comap,frb,ctrlmap]=comapx(mm,tms,chs,thr)

if nargin<4
  thr=[];
end

t0=min(tms); t1=max(tms);
dt = (t1-t0)./length(tms);

frb = hist(chs,[0:59])./(dt+t1-t0) + 1e-9;

M=length(mm.onset);
C=size(mm.cspks,2);

if isfield(mm,'qonset');
  tt0 = mm.qonset;
  tt1 = mm.qoffset;
  dt = tt1-tt0;
  tt0 = tt0 - dt*1.1;
  tt1 = tt1 + dt*1.1;
else
  tt0 = mm.monset;
  tt1 = mm.moffset;
  dt = tt1-tt0;
  tt0 = tt0 - dt*1.2;
  tt1 = tt1 + dt*1.2;
end

comap=zeros(M,60);
for m=1:M
  fprintf(1,' (comapx-1: %i/%i)     \r',m,M);
  t0 = tt0(m); t1=tt1(m);
  idx=find(tms>=t0 & tms<=t1);
  fr = hist(chs(idx),[0:59])./(t1-t0);
  comap(m,:) = fr ./ frb;
end
if nargout>=3
  ctrlmap=zeros(M,60);
  for m=1:M
    fprintf(1,' (comapx-2: %i/%i)\r   ',m,M);
    dt = tt1(m)-tt0(m); t0=rand(1,1)*(max(tms)-min(tms)-dt)+min(tms);
    idx=find(tms>=t0 & tms<=t1);
    fr = hist(chs(idx),[0:59])./(t1-t0);
    ctrlmap(m,:)=fr ./ frb;
  end
end
fprintf(1,'\n');

if ~isempty(thr);
  comap = comap>thr;
end
