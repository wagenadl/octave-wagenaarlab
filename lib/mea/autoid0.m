function [id,guide,dx]=autoid0(v,tol,guide,epsi)
% id=AUTOID0(v,tol) automatically assigns IDs to the A1 markers in V (which
% must be floats ranged 0..4096).
% TOL specifies the tolerance, default is 50.
% [id,guide]=AUTOID0(...) also returns a structure that can be used to
% apply the same identification to another set of points:
% id=AUTOID0(v,[],guide) uses a previously returned guide.
% id=AUTOID0(...,epsi) does not create clusters with less than EPSI members.
% [id,guide,dx] also returns distance from cluster peak
%
% Difference with AUTOID is that AUTOID0 assigns cluster 0 to cluster closest
% to 2048, +ve down, -ve up, nan for unclustered.

if nargin<2 | isempty(tol)
  tol=50;
end

id=0.*v + nan;

[X Y] = size(v);

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

vc=v;
n=1;
pos=[];

% Create cluster at 2048, the center point:
y0=2048;
pos=[pos y0];
idx=find(vc>=y0-tol & vc<=y0+tol);
mn=max([ceil(y0-tol) 1]);
mx=min([floor(y0+tol) length(x)]);
x(mn:mx)=0;
vc(idx)=nan;
n=n+1;

% Create other clusters:
while max(x)>0
  [h0,y0] = max(x);
  idx=find(vc>=y0-tol & vc<=y0+tol);
  if length(idx)>=epsi
    id(idx) = n;
    pos=[pos y0];
    n=n+1;
  end
  mn=max([ceil(y0-tol) 1]);
  mx=min([floor(y0+tol) length(x)]);
  x(mn:mx)=0;
  vc(idx)=nan;
end

[pp,ii]=sort(pos); 
P=length(pp); V=length(v);
dx = repmat(v(:),1,P) - repmat(pp(:)',V,1);
[dx,id] = min(dx.^2,[],2);

dp = (pp-2048).^2; [mn,of] = min(dp); 
id = of - id;

if X==1
  id=id(:)';
  dx=dx(:)';
else
  id=id(:);
  dx=dx(:);
end
