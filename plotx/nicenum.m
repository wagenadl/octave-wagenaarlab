function y = nicenum(x, sig, up)
% y = NICENUM(x, sig) rounds the number(s) X toward zero, to the neareast
% "nice" number. What is considered nice, is determined by SIG:
%
% SIG=1: 1
% SIG=2: 1 2 5
% SIG=3: 1 2 ... 9
% SIG=4: 1 1.5 2.0 ... 9.5
% SIG=5: 1 1.2 1.5 2 2.5 3 4 ... 9
% SIG=6: 1 1.1 1.2 ... 1.6 1.8 2 2.2 2.4 2.5 2.6 2.8 3 3.5 4 ... 9.5
% SIG=7: 1 1.1 ... 9.9
%
% SIG=10: 1 1.1 1.2 ... 1.9 2 3 4 5 6 7 8 9
% SIG=11: 1 1.1 1.2 ... 2.9 3 4 5 6 7 8 9
%
% (Times some power of ten.)
% SIG=1..7 are designed for axes labels and such. These contain numbers that
% intuitively feel less precise (1.8 feels less precise than 1.7).
% SIG=10...11 are meant for reporting uncertainty values. These contain all
% numbers with 2 digits up to some point, then numbers with 1 digit.
%
% y = NICENUM(x, sig, 1) rounds away from zero
% y = NICENUM(x, sig, 0) rounds to nearet
% 
% Caution: round to nearest has a bias of 5e-14 to round up, to ensure that
% e.g. 8.75 gets rounded to 8.8 rather than 8.7 for SIG=7. At this level of 
% detail, double precision isn't really good enough.
% y = NICENUM(x, sig, nan) prevents this bias.

if nargin<3
  up=-1;
end

vals{1} = [1 10];
vals{2} = [1 2 5 10];
vals{3} = [1:10];
vals{4} = [1:.5:10];
vals{5} = [1 1.2 [1.5:.5:3] [4:10]];
vals{6} = uniq(sort([[1:.2:3] [1:.1:1.5] [1:.5:10]]));
vals{7} = [1:.1:10];

vals{10} = [[1:.1:2] [3:10]];
vals{11} = [[1:.1:3] [4:10]];


sgn = sign(x);
lx = log10(abs(x));
l10 = floor(lx);
dig = 10.^(lx-l10);

try 
  vv = vals{sig};
  if isempty(vv)
    error('x');
  end
catch
  error('Bad value for SIG');
end
N=length(vv);
S = size(x); L=prod(S);
dig = reshape(dig,[1 L]);
ok = logical(zeros(N, L));

if up>0
  for n=1:N
    ok(n,:) = dig>vv(n);
  end
  dig = vv(sum(ok)+1);
elseif up<0
  for n=1:N
    ok(n,:) = dig>=vv(n);
  end
  dig = vv(sum(ok));
else
  ok2 = logical(zeros(N, L));
  for n=1:N
    ok(n,:) = dig>=vv(n);
    ok2(n,:) = dig>vv(n);
  end
  dig1 = vv(sum(ok));
  dig2 = vv(sum(ok2)+1);
  del1 = dig-dig1;
  del2 = dig2-dig;
  if isnan(up)
    lrg = del1 >= del2;
  else
    lrg = del1 >= del2 - 5e-14;
  end
  dig = dig1;
  dig(lrg) = dig2(lrg);
end

dig = reshape(dig,S);

y = sgn .* dig .* 10.^l10;

