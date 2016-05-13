function eq = equal(a,b)
% EQUAL - Test if two numbers are very nearly the same
%   EQUAL(a, b) returns true if the difference between A and B is 
%   less than 1e-10 or less than 1e-10*max(abs(a),abs(b)), whichever is more.
%   EQUAL(a) tests A against zero.

if nargin<2
  b = 0;
end

thr = 1e-10 * max([1; abs(a(:)); abs(b(:))]);
eq = abs(a-b) < thr;
