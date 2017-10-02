function H = kruskal_wallis(a,b)
% H = KRUSKAL_WALLIS(a,b) returns the Kruskal-Wallis rank test for
% two groups A and B.
% H = KRUSKAL_WALLIS(a), where A is a cell array, does the same for
% arbitrary number of groups.
% Result is approx. chi2 distributed if null-hyp holds, with dof = #groups-1.
%
% From Sokal and Rohlf, Biometry, 3rd ed, pp 423ff.
% Warning: number of elements should be at least 5 per group, or chi2
% assumption does not hold (op.cit. p.426).
if nargin==2
  a = {a, b};
end

src = [];
val = [];
nn = [];
GRP = length(a);
for grp=1:GRP
  nn(grp) = length(a{grp});
  src = [src repmat(grp,1,length(a{grp}))];
  val = [val a{grp}(:)'];
end

[r,ties] = drank(val);

sumR = 0*nn;
for grp=1:GRP
  sumR(grp) = sum(r(src==grp));
end
totnn = sum(nn);

H = (12 * sum(sumR.^2./nn)) ./ (totnn .* (totnn+1)) - 3*(totnn+1);

tt = (ties-1).*ties.*(ties+1);
D = 1 - sum(tt) ./ ((totnn-1).*totnn.*(totnn+1));

H = H./D;
