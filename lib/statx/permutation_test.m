function [p, v0, vv] = permutation_test(xx, yy, N, foo)
% PERMUTATION_TEST - p-value for a permutation test
%    p = PERMUTATION_TEST(xx, yy, n) performs a permutation test to see if the
%    mean of XX is less than (p close to 0) or more than (p close to 1) the
%    mean of YY. N is the number of permutations used (default: 10,000).
%
%    p = PERMUTATION_TEST(xx, yy, n, func) specifies an alternative function.
%    FUNC can be the name of a function, e.g., "median", in which case the 
%    test is for median(xx) <=> median(yy).
%    FUNC can also be a function handle, in which case the test is for
%    func(xx, yy) <=> 0.
%    For instance, the default behavior is equivalent to
%    func = @(x,y) (mean(x) - mean(y)).
%
%    [p, v0, vv] = PERMUTATION_TEST(...) additionally returns the actual test
%    statistic V0 and the N test statistics VV from the permutations.

if nargin<3
  N = 10000;
end

if nargin<4
  foo = 'mean';
end

X = length(xx);
Y = length(yy);

if isempty(xx) || isempty(yy)
  p = 0.5;
  v0 = nan;
  vv = nan + zeros(N,1);
  return;
end

if ischar(foo)
  foo = eval(sprintf('@(x,y) (%s(x) - %s(y))', foo, foo));
end

v0 = foo(xx, yy);

vv = zeros(N, 1);
xy = [xx(:); yy(:)]; 

for n=1:N
  idx = randperm(X+Y);
  vv(n) = foo(xy(idx(1:X)), xy(idx(X+1:end)));
end

vv = sort(vv);

idx = find(vv>=v0, 1);
if isempty(idx)
  idx = N;
end
p = (idx - 0.5) / N;

if nargout<3
  clear vv
end
if nargout<2
  clear v0
end
