function [id,guide]=niceid(v,tol,guide,epsi)
% id=NICEID(v,tol) automatically assigns IDs to the A1 markers in V (which
% must be floats ranged 0..4096).
% TOL specifies the tolerance, default is 50.
% [id,guide]=NICEID(...) also returns a structure that can be used to
% apply the same identification to another set of points:
% id=NICEID(v,[],guide) uses a previously returned guide.
% id=NICEID(...,epsi) assigns id=nan to clusters with less than EPSI members.
% Clusters are numbered like this: the cluster closest to 2048 is number 0,
% clusters below 2048 are positive (order of increasing distance to 2048), 
% clusters above 2048 are negative (order of increasing distance to 2048).

if nargin<2 | isempty(tol)
  tol=50;
end

id=0.*v;

y=[1:4096];
if nargin<3 | isempty(guide)
  x=hist(v,y);
else
  x=guide.x;
  tol=guide.tol;
end

if nargin<4 | isempty(epsi)
  epsi=0;
end

if nargout>1
  guide = struct('x',x, 'tol', tol);
end

n=1;
pos=[];
while max(x)>0
  [h0,y0] = max(x);
  idx=find(v>=y0-tol & v<=y0+tol);
  if length(idx)>=epsi
    id(idx) = n;
    pos=[pos y0];
    n=n+1;
  end
  x(ceil(y0-tol):floor(y0+tol))=0;
end

[pp,ii]=sort(pos);
jj=[1:n-1];
kk(ii)=jj;
kk(n)=nan;
id(id==0)=n;
id = kk(id);
[mm,ofs] = min((pp-2048).^2);
id = ofs - id;
