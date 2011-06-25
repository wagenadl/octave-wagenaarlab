function p=fitexp(xx,yy,p0)
% p = fitexp2(xx,yy,[a0,b0,c0]) fits yy=a0*exp(-xx/b0)+c0, but keeps c0 fixed.
c=p0(3)
p0=p0(1:2)
p = fminsearch(@foo,p0,[],xx,yy,c);
p=[p c];

function chi=foo(p,xx,yy,c)
zz=p(1) * exp(-xx/p(2)) + c;
chi=sum((yy-zz).^2);
