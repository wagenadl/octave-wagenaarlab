function dx=sensibleminor(mx)
% dx = SENSIBLEMINOR(mx) returns a sensible step size for minor ticks given
% tick spacing MX.

lg=log10(mx);
ord=floor(lg);
sub=10.^(lg-ord);

if sub>5.01
  sub=2;
elseif sub>2.01
  sub=1;
elseif sub>1
  sub=.5;
else
  sub=.2;
end
dx = sub * 10^ord;
