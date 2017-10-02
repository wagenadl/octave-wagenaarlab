function a = bestsubtract(xx,yy,a0)
% a = BESTSUBTRACT(xx,yy) finds the value of A that minimizes
%
%    sum((XX-A*YY).^2).
% 
%  a = BESTSUBTRACT(xx,yy,a0) specifies an initial estimate.

if nargin<3
  a0=1;
end

a = fminsearch(@foo,a0,[],xx,yy);

function chi = foo(a,xx,yy)
chi = sum((xx(:)-a*yy(:)).^2);
