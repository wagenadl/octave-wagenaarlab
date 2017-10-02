function dx=sensiblestepup(mx,sml)
% dx = SENSIBLESTEPUP(mx) returns a sensible step size not much larger
% than MX:
%
%   1<=MX<2  -> DX=2
%   2<=MX<5  -> DX=5
%   5<=MX<10 -> DX=10
%   etc.
%
% dx = SENSIBLESTEPUP(mx,1) is less picky:
% Accepted steps are 1, 1.2, 1.5, 2, 2.5, 3, 4, 5, 6, 8.

if  nargin<2 
  sml=0;
end

lg=log10(mx);
ord=floor(lg);
sub=10.^(lg-ord);

if sml
  if sub>8
    sub=10;
  elseif sub>6
    sub=8;
  elseif sub>5
    sub=6;
  elseif sub>4
    sub=5;
  elseif sub>3
    sub=4;
  elseif sub>2.5
    sub=3;
  elseif sub>2
    sub=2.5;
  elseif sub>1.5
    sub=2;
  elseif sub>1.2
    sub=1.5;
  else
    sub=1.2;
  end
else
  if sub>5
    sub=10;
  elseif sub>2
    sub=5;
  else
    sub=2;
  end
end

dx = sub * 10^ord;
