function [bb,cc,dd,ss,tt]=getsimmux(spk)

addpath('~wagenaar/matlab/simmux');

idx=spk.chs<60;
tms=spk.tms(idx); 
chs=spk.chs(idx); 

bb=simplexburst(tms,chs,0.300,4,0.500,4,5); % was 7,10

if nargout>=2
  cc=multixburst(bb);
  [cc.gonset cc.goffset] = gonsetx(cc,bb,tms);
end

if nargout>=3
  dd = disjoinxburst(cc,bb,tms,chs);
  kk=bigxburst(dd,.25);
  dd.isbig = logical(zeros(size(dd.onset))); dd.isbig(kk)=logical(1);
end

if nargout>=4
  ss=superxburst(dd,kk,10,2);
end

if nargout>=5
  tt=expandxburst(ss,dd,kk,1);
end
