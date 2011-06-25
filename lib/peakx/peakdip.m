function [peaks,dips]=peakdip(yy,radius,thrfac,thrabs,plotflag)

if nargin<2 | isempty(radius)
  radius=10;
end

if nargin<3 | isempty(thrfac)
  thrfac=1;
end

if nargin<4 | isempty(thrabs)
  thrabs=0;
end

if nargin<5 | isempty(plotflag)
  plotflag=0;
end

yy=yy(:); L=length(yy);

ispeak=logical(ones(L,1));
isdip=logical(ones(L,1));
for r=[-radius:-1]
  y1=shift(yy,r);
  ispeak = ispeak & (yy>y1);
  isdip = isdip & (yy<y1);
end
for r=[1:radius]
  y1=shift(yy,r);
  ispeak = ispeak & (yy>=y1);
  isdip = isdip & (yy<=y1);
end

isdip(1)=1;
isdip(end)=1;

ntotal=length(find(isdip))+length(find(ispeak));
ntotal0=0;

if plotflag
  clf
end

while ntotal~=ntotal0
  ntotal0=ntotal;

  both=ispeak-isdip;
  x0=0;
  while x0<L
    ii=find(both(x0+1:end))+x0;
    if isempty(ii)
      break
    end
    me=ii(1);
    if length(ii)>1
      nxt=ii(2);
    else
      nxt=inf;
    end
    ii=find(both(1:me-1));
    if isempty(ii)
      prv=-inf;
    else
      prv=ii(end);
    end
    if nxt<inf & both(nxt)==both(me) & ...
  	  sign(yy(me)-yy(nxt))~=both(me)
      both(me)=0;
    elseif prv>-inf & both(prv)==both(me) & ...
  	  sign(yy(prv)-yy(me))==both(me)
      both(me)=0;
    end
    x0=me;
  end
  ispeak=both>0;
  isdip=both<0;
  
  
  if plotflag
    peaks=find(ispeak);
    dips=find(isdip);
    plot(yy,'.-')
    hold on
    plot(peaks,25,'*r')
    plot(dips,20,'*m')
  end
   
  both=ispeak | isdip;
  ibo=find(both);
  ybo = yy(ibo);
  B=length(ibo);
  sgn=ispeak(ibo)-isdip(ibo);
  for b=2:B-1
    diffl = ybo(b)-ybo(b-1);
    diffr = ybo(b)-ybo(b+1);
    ratiol = ybo(b)/ybo(b-1);
    ratior = ybo(b)/ybo(b+1);
    if plotflag
      fprintf(2,'%4i: %6.3g %6.3g l=%4.3g\n',ibo(b),ratiol,ratior,log(ratiol*ratior)/log(2));
      fprintf(2,'    : %6.3g %6.3g l=%4.3g\n',diffl,diffr,diffl+diffr);
    end
  
    if abs(log(ratiol*ratior))<2*log(thrfac) | abs(diffl+diffr)<2*thrabs
      if (b>2 & sign(ybo(b)-ybo(b-2))~=sgn(b)) | ...
  	    (b<B-1 & sign(ybo(b+2)-ybo(b))==sgn(b))
  	ispeak(ibo(b))=0;
  	isdip(ibo(b))=0;
      end
    end
  end

  if plotflag
    peaks=find(ispeak);
    dips=find(isdip);
    plot(peaks,27,'*r')
    plot(dips,18,'*m')
  end
  ntotal=length(find(isdip))+length(find(ispeak));
end

peaks=find(ispeak);
dips=find(isdip);

if plotflag
  plot(peaks,29,'*r')
  plot(dips,16,'*m')
  
  l=line([0 L],[22.5 22.5]);
  set(l,'linestyle',':')
end
