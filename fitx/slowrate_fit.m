ser = { 'cono1', 'cono2', 'cono3', 'cut1', 'cut2', 'saline1', 'saline2' };
S=length(ser);
F=4;
C=4;
E=8;
omega=zeros(F,C,E,S);
phase=zeros(F,C,E,S);
ampl =zeros(F,C,E,S);
period=zeros(F,C,1,S);
phas_=zeros(F,C,E,S);
ampl_=zeros(F,C,E,S);
err_=zeros(F,C,E,S);
dt=zeros(F,C,E,S);
avgfr=zeros(F,C,E,S);

[b,a]=lowpass1(1/100);

for s=1:S
  load(sprintf('sc/%s-sc.mat',ser{s}));
  sc=recombine(sc);

  useclu=zeros(E,sc.CLU);
  for elc=1:E
    for clu=1:sc.CLU
      for cel=C:-1:1
	if ~isempty(strmatch(sprintf('%i',cel),sc.labels{elc,clu}));
	  useclu(elc,clu)=cel;
	end
      end
    end
  end
  
  ttt=cell(F,C,E);
  zzz=cell(F,C,E);

  for fno=1:F
    for cel=1:C
      fprintf(1,'Working on series %i/%i fno %i/%i cel %i/%i (1)\n',s,S,fno,F,cel,C);
      for elc=1:E
	idx = find(sc.elc==elc & sc.fno==fno & useclu(elc,sc.clu)'==cel);
	if ~isempty(idx)
	  t0=floor(min(sc.tms(idx)));
	  t1=ceil(max(sc.tms(idx)));
	  avgfr(fno,cel,elc,s) = (length(idx)-1)/(t1-t0);
	  tt=[t0:t1]+.5;
	  dt(fno,cel,elc,s) = length(tt);
	  if length(tt)>10
	    yy = hist(sc.tms(idx),tt);
	    zz = filtfilt(b,a,yy);
	    idx=find(tt>t0+120);
	    zz=zz(idx); tt=tt(idx);
	    zz = zz./(mean(zz)+.5);
	    if length(idx)>10
	      ttt{fno,cel,elc}=tt;
	      zzz{fno,cel,elc}=zz;
	      [omega(fno,cel,elc,s),phase(fno,cel,elc,s),ampl(fno,cel,elc,s)] = ...
		  fitsine2(tt/60,detrend(zz));
	    end
	  end
	end
      end
    end
  end
  period(:,:,:,s) = sum((2*pi/omega(:,:,:,s)).*ampl(:,:,:,s).*dt(:,:,:,s),3)./ ...
      sum(ampl(:,:,:,s).*dt(:,:,:,s),3); % get mean period per cell type, 
  % weighted by amplitude and duration of recording (a measure of confidence)
  
  for fno=1:F
    for cel=1:C
      fprintf(1,'Working on series %i/%i fno %i/%i cel %i/%i (2)\n',s,S,fno,F,cel,C);
      for elc=1:E
	tt = ttt{fno,cel,elc};
	zz = zzz{fno,cel,elc};
	if ~isempty(tt)
	  [ampl_(fno,cel,elc,s),phas_(fno,cel,elc,s),err_(fno,cel,elc,s)] = ...
	      fitcos(detrend(zz),period(fno,1,1,s),tt/60,ampl(fno,cel,elc,s),phase(fno,cel,elc,s));
	end
      end
    end
  end
end

desc = 'Most variables are FNOxCELxELCxSER.';

save ana/slowrate.mat omega phase ampl period ampl_ phas_ err_ series avgfr desc

