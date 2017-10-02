function alpha = sincossolve(p,q)
% SINCOSSOLVE   Solves the eqn p*sin(alpha) + q*cos(alpha) = 1.
%   alpha = SINCOSSOLVE(p,q).
%   This uses the solutions:
%
%                    q +- p sqrt(p^2+q^2-1) 
%      cos(alpha) = ------------------------
%                          p^2 + q^2        
%
%   This works for any shape p, q. For scalar p, q, the result is 2x1.
%   If their shape is 1xN, the result is 2xN. Otherwise, if they are
%   shape NxMxPx..., the result is NxMxPx2.

S=size(p); SS=prod(S);
p=reshape(p,[SS 1]);
q=reshape(q,[SS 1]);

D=p.^2+q.^2-1;
sD=p.*sqrt(D);
b = q; 
twoa = p.^2+q.^2;

cosa = [(b+sD)./twoa, (b-sD)./twoa];
alpha = acos(cosa);
alpha(D<0,:)=nan;
alpha(abs(cosa)>1)=nan;
alpha=real(alpha);
idx = q>sign(p);
alpha(idx,1)=-alpha(idx,1);
idx = q<-sign(p);
alpha(idx,2)=-alpha(idx,2);

if length(S)==2 & S(1)==1
  alpha = alpha';
else
  alpha = reshape(alpha,[S 2]);  
end