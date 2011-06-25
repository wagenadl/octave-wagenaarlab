function str=artifave(raw);
st=std(raw'); mn=mean(st);
ordi=find((st>mn*.95) & (st<mn*1.05));
rw=raw(ordi,:);
rr=0.*rw;
[C T]=size(rw);
mn=zeros(1,T);
for t=1:T
  cc=find((rw(:,t)>0) & (rw(:,t)<4095));
  if length(cc)>0
    rr(cc,t)=rw(cc,t);
    mn(t)=mean(rw(cc,t));
  end
end
str.x=rw;
str.y=rr;
str.mn=mn;
str.ordi=ordi;

return;

for r=1:C
  r
  idx=find((str.x(r,:)>0) & (str.x(r,:)<4095));
  cc=corrcoef(str.y(r,idx),str.mn(idx));
  plot([1:T]/25,str.y(r,:)-cc(1,2)*str.mn,'r-',[1:T]/25,str.x(r,:)-2000,'b-',[1:T]/25,str.mn-2000,'m-');
  axis([(2000/25) (18000/25) -100 500]);
  drawnow;
  pause;
end
