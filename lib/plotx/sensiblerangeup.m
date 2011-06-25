function y = sensiblerange(x,digs)
% y = SENSIBLERANGE(x) returns a number Y s.t. |Y| >= |X| that is pleasing 
% to the eye. Y will preserve the sign of X.
% y = SENSIBLERANGE(x,digs) specifies how many digits of significance will be
% retained. DIGS does not need to be integer.

if nargin<2
  digs=1.5;
end

sgn=sign(x);
x=abs(x);

l10 = log10(x);
l10f = floor(l10);
stp = 10^(l10-digs+1);
stpa = sensiblestep(stp);
stpb = sensiblestepup(min([stp stpa*1.001]));
ya = ceil(x/stpa)*stpa;
yb = ceil(x/stpb)*stpb;
y=min([ya yb]);
y = sgn*y;
