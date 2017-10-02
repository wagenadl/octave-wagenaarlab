function p=fitexp_fix_tau(xx,yy,p0)
% p = FITEXP(xx,yy,[a0,b0,c0]) fits yy=a0*exp(-xx/b0)+c0, keeping b0 fixed.
p = fminsearch(@foo,p0([1 3]),[],xx,yy,p0(2));
p = [p(1) p0(2) p(2)];

function chi=foo(p,xx,yy,tau)
zz=p(1) * exp(-xx/tau) + p(2);
chi=sum((yy-zz).^2);
