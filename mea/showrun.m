function l=showrun(rr,y)
R=length(rr.start);
l=zeros(1,R);
for r=1:R
  l(r)=line([rr.start(r) rr.end(r)],[y y]);
end
