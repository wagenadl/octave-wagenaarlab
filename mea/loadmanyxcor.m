function dat=loadmanyxcor(fnbase,num,norma)
if nargin<3
  norma=0;
end

k=1;
for n=num
    fprintf(2,'Loading %i\n',n);
  dat{k}=loadcor(sprintf(fnbase,n));
%  fprintf(2,'Normalizing %i\n',n);
%  for c=1:64
%    for d=1:64
%      nor = max(dat{k}{c}{d});
%      if nor>0
%	 dat{k}{c}{d} = dat{k}{c}{d} ./ nor;
%      end
%    end
%  end
  k=k+1;
  whos
end
