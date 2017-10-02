function [gon,gof]=gonsetx(mm,bb,tms)
t0=min(tms); t1=max(tms); dt=0.025;
tt=[t0:dt:t1];
yy=gaussianblur1d(hist(tms,tt),6);
M=length(mm.onset);
y0=mean(yy);
zz=gaussianblur1d(yy,4);
gg.gonset=zeros(M,1)+nan;
gg.goffset=zeros(M,1)+nan;
for m=1:M
  i0=findfirst_ge(tt,mm.monset(m));
  st=findlast_lt(zz(1:i0),y0);
  en=findfirst_lt(zz(i0+1:end),y0);
  if st==0
    st=1;
  end
  if en==0
    en=length(tt);
  else
    en=i0+en;
  end
  gg.gonset(m)=tt(st);
  gg.goffset(m)=tt(en);
end

if nargout>=2
  gon = gg.gonset;
  gof = gg.goffset;
else
  gon = gg;
end
