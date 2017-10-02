function [stm,ser,n]=stmser(trg)
% [stm,ser,n] = STMSER(trg) returns stimulus and series identities
% Tries to get stimhw from trg(:,1:2), series from trg(:,3), and 
% within series number from trg(:,4).
cc=trg(:,1);
C=max(cc);
if C>8
  hh=hist(cc,[0:C]);
  [hh,oo]=sort(hh);
  use=logical(zeros(1,C+1));
  use(oo(C-6:C+1))=1;
  map=cumsum(use(2:end));
  cc(cc>0) = map(cc(cc>0));
elseif C<8 & min(cc)>0
  cc(cc>0)=cc(cc>0)+1;
end
rr=trg(:,2);
R=max(rr);
if R>8
  hh=hist(rr,[0:R]);
  [hh,oo]=sort(hh);
  use=logical(zeros(1,R+1));
  use(oo(R-6:R+1))=1;
  map=cumsum(use(2:end));
  rr(rr>0) = map(rr(rr>0));
elseif R<8 & min(rr)>0
  rr(rr>0)=rr(rr>0)+1;
end
stm = cr2hw(cc,rr);

if nargout>=2
  ser=trg(:,3);
end
if nargout>=3 
  if size(trg,2)>=4
    n=trg(:,4);
  else
    n=0*ser;
  end
end
