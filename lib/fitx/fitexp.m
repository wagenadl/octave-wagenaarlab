function p=fitexp(xx,yy,p0)
% p = FITEXP(xx,yy,[a0,b0,c0]) fits yy=a0*exp(-xx/b0)+c0.
p = fminsearch(@foo,p0,[],xx,yy);

function chi=foo(p,xx,yy)
zz=p(1) * exp(-xx/p(2)) + p(3);
chi=sum((yy-zz).^2);
