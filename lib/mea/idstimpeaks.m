function [num,map]=idstimpeaks(ids,delta)
% num=IDSTIMPEAKS(ids) assigns numbers to each peak in the histogram of IDS,
% and assigns one such number to each value in IDS. IDS must be the output
% of idstim (part of meabench). The second and third column of IDS are treated
% completely independently. Numbers are assigned in peak location order.
% num=IDSTIMPEAKS(ids,delta) specifies how wide the peaks may be. DELTA 
% defaults to 15.
% [num,map]=IDSTIMPEAKS(...) returns the mapping as well, in a cell array.
if nargin<2
  delta=15;
end
num=ids*0; num(:,1)=ids(:,1);
N=size(ids,1);
map=cell(1,3);
for k=2:3
  n=1;
  ok=1;
  while ok
    ii=find(num(:,k)==0);
    h=hist(ids(ii,k),[1:4095]);
    [my,mx]=max(h)
    if my>=5
      jj=ii(find(ids(ii,k)>mx-delta & ids(ii,k)<mx+delta));
      h(max([1 ceil(mx-delta)]):min([floor(mx+delta) 4095]))=0;
      num(jj,k)=n;
      map{k} = [map{k} mx];
      n=n+1;
    else
      ok=0;
    end
  end
  [mm,oo]=sort(map{k});
  pp=[1:length(oo)]';
  pp(oo)=pp;
  map{k}=mm;
  jj=find(num(:,k)>0);
  num(jj,k)=pp(num(jj,k));
end

    