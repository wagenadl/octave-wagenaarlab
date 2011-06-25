function [bb,cc,dd,ss,tt] = simmux(tms,chs)
% [bb,cc,dd,ss,tt] = SIMMUX(tms,chs)

addpath /home/wagenaar/matlab/simmux

bb=simplexburst(tms,chs,0.5,4,1,0.001,0.001); % was 7,10

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
