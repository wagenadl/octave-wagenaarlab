function ii = cmgaus(vv,ii,cwid)
% ii = CMGAUS(vv,ii,cwid) returns the center-of-mass of events in VV at 
% approximate locations II using Gaussian window of half-width CWID.
% Areas before and after VV are zero-padded.
% ii = CMGAUS(ctxt,cwid) does the same in pre-extracted windows

if nargin==2
  cwid=ii;
  [W,N] = size(vv); T=floor(W/2);
  ii = zeros(N,1);
  for n=1:N
    ww=vv(:,n);
    tt=[-T:T]';
    gaus=exp(-(tt/cwid).^2);
    ww=ww.^2.*gaus;
    sww = sum(ww);
    swwt = sum(ww.*tt);
    ii(n) = swwt./sww;
  end
  
else

  N=length(ii);

  vv = [zeros(3*cwid,1); vv(:); zeros(3*cwid,1)];
  
  for n=1:N
    i0 = ii(n)-3*cwid + 3*cwid;
    i1 = ii(n)+3*cwid + 3*cwid;
    
    ww = vv(i0:i1);
    tt=[-3*cwid:3*cwid]';
    gaus = exp(-(tt/cwid).^2);
    
    ww=ww.^2.*gaus;
    sww = sum(ww);
    swwt = sum(ww.*tt);
    
    ii(n) = ii(n) + swwt./sww;
  end
end
